# Currently doesn't work with CrowdStrike due to protections (I need to further debug).  However, it works locally in the context of NT Authority\System.

Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;

public class UserTokenRunner
{

    const uint SE_PRIVILEGE_ENABLED = 0x00000002;

    [StructLayout(LayoutKind.Sequential)]
    struct LUID { public uint LowPart; public int HighPart; }

    [StructLayout(LayoutKind.Sequential)]
    struct TOKEN_PRIVILEGES
    {
        public uint PrivilegeCount;
        public LUID Luid;
        public uint Attributes;
    }

    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges,
        ref TOKEN_PRIVILEGES NewState, int BufferLength, IntPtr PreviousState, IntPtr ReturnLength);

    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out LUID lpLuid);

    static bool EnablePrivilege(string privName)
    {
        IntPtr hToken;
        if (!OpenProcessToken(Process.GetCurrentProcess().Handle, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, out hToken))
            return false;

        LUID luid;
        if (!LookupPrivilegeValue(null, privName, out luid))
            return false;

        TOKEN_PRIVILEGES tp = new TOKEN_PRIVILEGES
        {
            PrivilegeCount = 1,
            Luid = luid,
            Attributes = SE_PRIVILEGE_ENABLED
        };

        bool result = AdjustTokenPrivileges(hToken, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        CloseHandle(hToken);
        return result;
    }

    const uint TOKEN_DUPLICATE = 0x0002;
    const uint TOKEN_QUERY = 0x0008;
    const uint TOKEN_ASSIGN_PRIMARY = 0x0001;
    const uint TOKEN_ADJUST_PRIVILEGES = 0x0020;
    const uint TOKEN_ALL_ACCESS = 0xF01FF;
    const uint CREATE_NO_WINDOW = 0x08000000;
    const int SecurityImpersonation = 2;
    const int TokenPrimary = 1;

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct STARTUPINFO
    {
        public int cb;
        public string lpReserved;
        public string lpDesktop;
        public string lpTitle;
        public uint dwX, dwY, dwXSize, dwYSize;
        public uint dwXCountChars, dwYCountChars;
        public uint dwFillAttribute;
        public uint dwFlags;
        public short wShowWindow;
        public short cbReserved2;
        public IntPtr lpReserved2;
        public IntPtr hStdInput, hStdOutput, hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION
    {
        public IntPtr hProcess;
        public IntPtr hThread;
        public uint dwProcessId;
        public uint dwThreadId;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct SID_AND_ATTRIBUTES
    {
        public IntPtr Sid;
        public int Attributes;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct TOKEN_USER
    {
        public SID_AND_ATTRIBUTES User;
    }

    [DllImport("kernel32.dll")]
    static extern IntPtr OpenProcess(uint access, bool inherit, uint pid);

    [DllImport("kernel32.dll")]
    static extern bool CloseHandle(IntPtr handle);

    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool OpenProcessToken(IntPtr processHandle, uint desiredAccess, out IntPtr tokenHandle);

    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool DuplicateTokenEx(IntPtr existingToken, uint desiredAccess, IntPtr tokenAttributes,
        int impersonationLevel, int tokenType, out IntPtr newToken);

    [DllImport("advapi32.dll", SetLastError = true)]
    static extern bool GetTokenInformation(IntPtr TokenHandle, int TokenInformationClass,
        IntPtr TokenInformation, int TokenInformationLength, out int ReturnLength);

    [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    static extern bool LookupAccountSid(string lpSystemName, IntPtr Sid,
        StringBuilder Name, ref int cchName, StringBuilder ReferencedDomainName, ref int cchRefDomainName, out int peUse);

    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool CreateProcessAsUser(
        IntPtr token,
        string appName,
        string commandLine,
        IntPtr procAttrs,
        IntPtr threadAttrs,
        bool inheritHandles,
        uint flags,
        IntPtr env,
        string cwd,
        ref STARTUPINFO si,
        out PROCESS_INFORMATION pi);

    static string GetUsernameFromToken(IntPtr token)
    {
        int len = 0;
        GetTokenInformation(token, 1, IntPtr.Zero, 0, out len);
        IntPtr buffer = Marshal.AllocHGlobal(len);
        if (!GetTokenInformation(token, 1, buffer, len, out len)) return null;

        TOKEN_USER tu = (TOKEN_USER)Marshal.PtrToStructure(buffer, typeof(TOKEN_USER));

        StringBuilder name = new StringBuilder(256);
        StringBuilder domain = new StringBuilder(256);
        int nameLen = 256;
        int domainLen = 256;
        int useType = 0;

        bool resolved = LookupAccountSid(null, tu.User.Sid, name, ref nameLen, domain, ref domainLen, out useType);
        Marshal.FreeHGlobal(buffer);

        if (!resolved) return null;
        return domain.ToString() + "\\" + name.ToString();
    }

    public static void RunAsUser(string targetUser, string cmd)
    {
        string logPath = @"C:\Windows\Temp\results.log";
        using (StreamWriter writer = new StreamWriter(logPath, true, Encoding.UTF8))
        {
            writer.WriteLine("[*] Attempting to run as user: " + targetUser);
            EnablePrivilege("SeAssignPrimaryTokenPrivilege");
            EnablePrivilege("SeIncreaseQuotaPrivilege");

            foreach (var proc in Process.GetProcessesByName("explorer"))
            {
                IntPtr hProc = OpenProcess(0x0400, false, (uint)proc.Id);
                if (hProc == IntPtr.Zero) continue;
                writer.WriteLine("[+] Got handle to explorer.exe: " + hProc);

                IntPtr hToken;
                if (!OpenProcessToken(hProc, TOKEN_DUPLICATE | TOKEN_ASSIGN_PRIMARY | TOKEN_QUERY, out hToken))
                {
                    writer.WriteLine("[-] Failed to open token for process " + proc.Id);
                    CloseHandle(hProc);
                    continue;
                }
                writer.WriteLine("[+] Opened token: " + hToken);

                string owner = GetUsernameFromToken(hToken);
                writer.WriteLine("[*] Token belongs to: " + (owner ?? "NULL"));

                if (owner == null ||
                    !(owner.Equals(targetUser, StringComparison.OrdinalIgnoreCase) ||
                    owner.EndsWith("\\" + targetUser, StringComparison.OrdinalIgnoreCase)))
                {
                    writer.WriteLine("[-] Token not for target user: " + targetUser);
                    CloseHandle(hToken);
                    CloseHandle(hProc);
                    continue;
                }

                IntPtr hDupToken;
                if (!DuplicateTokenEx(hToken, TOKEN_ALL_ACCESS, IntPtr.Zero, SecurityImpersonation, TokenPrimary, out hDupToken))
                {
                    writer.WriteLine("[-] Failed to duplicate token");
                    CloseHandle(hToken);
                    CloseHandle(hProc);
                    continue;
                }
                writer.WriteLine("[+] Token duplicated");

                STARTUPINFO si = new STARTUPINFO();
                si.cb = Marshal.SizeOf(si);
                PROCESS_INFORMATION pi;

                string fullCmd = "powershell.exe -NoProfile -Command \"" + cmd + "\" > C:\\Windows\\Temp\\user_output.log";
                bool created = CreateProcessAsUser(hDupToken, null, fullCmd, IntPtr.Zero, IntPtr.Zero, false,
                                                CREATE_NO_WINDOW, IntPtr.Zero, null, ref si, out pi);

                if (created)
                {
                    writer.WriteLine("[+] Successfully launched process as " + owner);
                    CloseHandle(pi.hProcess);
                    CloseHandle(pi.hThread);
                }
                else
                {
                    writer.WriteLine("[-] Failed to launch process as " + owner);
                }

                CloseHandle(hDupToken);
                CloseHandle(hToken);
                CloseHandle(hProc);
                return;
            }

            writer.WriteLine("[-] No matching explorer.exe process found for user: " + targetUser);
        }
    }
}
"@

$targetUser = "USERNAME_HERE"
$command = "COMMAND_HERE"
[UserTokenRunner]::RunAsUser($targetUser, $command)
# Results logged to C:\Windows\Temp\user_output.log
# Debugging logged to C:\Windows\Temp\results.log

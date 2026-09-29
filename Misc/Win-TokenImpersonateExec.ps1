# UserTokenRunner - Enhanced Debug Build
# Adds:
# - Child process exit code logging
# - WaitForSingleObject()
# - user_output.log existence checks
# - Automatic temp script cleanup
# - Automatic output capture

Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.IO;
using System.Text;
using System.Security.Principal;

public class UserTokenRunner
{
    const uint SE_PRIVILEGE_ENABLED = 0x2;
    const uint TOKEN_DUPLICATE = 0x0002;
    const uint TOKEN_QUERY = 0x0008;
    const uint TOKEN_ASSIGN_PRIMARY = 0x0001;
    const uint TOKEN_ADJUST_PRIVILEGES = 0x0020;
    const uint TOKEN_ALL_ACCESS = 0xF01FF;
    const uint PROCESS_QUERY_INFORMATION = 0x0400;
    const uint CREATE_NO_WINDOW = 0x08000000;

    const uint WAIT_OBJECT_0 = 0x0;
    const uint WAIT_TIMEOUT = 0x102;

    const int SecurityImpersonation = 2;
    const int TokenPrimary = 1;

    [StructLayout(LayoutKind.Sequential)]
    struct LUID { public uint LowPart; public int HighPart; }

    [StructLayout(LayoutKind.Sequential)]
    struct TOKEN_PRIVILEGES {
        public uint PrivilegeCount;
        public LUID Luid;
        public uint Attributes;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct SID_AND_ATTRIBUTES {
        public IntPtr Sid;
        public int Attributes;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct TOKEN_USER {
        public SID_AND_ATTRIBUTES User;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct STARTUPINFO {
        public int cb;
        public string lpReserved;
        public string lpDesktop;
        public string lpTitle;
        public uint dwX,dwY,dwXSize,dwYSize;
        public uint dwXCountChars,dwYCountChars;
        public uint dwFillAttribute;
        public uint dwFlags;
        public short wShowWindow;
        public short cbReserved2;
        public IntPtr lpReserved2;
        public IntPtr hStdInput,hStdOutput,hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION {
        public IntPtr hProcess;
        public IntPtr hThread;
        public uint dwProcessId;
        public uint dwThreadId;
    }

    [DllImport("kernel32.dll")] static extern IntPtr OpenProcess(uint access, bool inherit, uint pid);
    [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);
    [DllImport("kernel32.dll", SetLastError=true)] static extern uint WaitForSingleObject(IntPtr h, uint ms);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool GetExitCodeProcess(IntPtr h, out uint exitCode);

    [DllImport("advapi32.dll", SetLastError=true)] static extern bool OpenProcessToken(IntPtr h, uint access, out IntPtr token);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool LookupPrivilegeValue(string sys, string priv, out LUID luid);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool AdjustTokenPrivileges(IntPtr h, bool d, ref TOKEN_PRIVILEGES tp, int len, IntPtr p, IntPtr r);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool DuplicateTokenEx(IntPtr existing, uint access, IntPtr attrs, int imp, int type, out IntPtr token);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool GetTokenInformation(IntPtr h, int cls, IntPtr buf, int len, out int ret);
    [DllImport("advapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)] static extern bool LookupAccountSid(string sys, IntPtr sid, StringBuilder name, ref int nl, StringBuilder dom, ref int dl, out int use);
    [DllImport("advapi32.dll", CharSet=CharSet.Unicode, SetLastError=true)] static extern bool CreateProcessAsUser(IntPtr token, string app, string cmd, IntPtr pa, IntPtr ta, bool inherit, uint flags, IntPtr env, string cwd, ref STARTUPINFO si, out PROCESS_INFORMATION pi);

    static void Log(StreamWriter w,string m){ w.WriteLine("["+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff")+"] "+m); w.Flush(); }
    static string LastErr(){ int e=Marshal.GetLastWin32Error(); return "Win32Error="+e+" (0x"+e.ToString("X8")+")"; }

    static string GetUsernameFromToken(IntPtr token){
        int len=0; GetTokenInformation(token,1,IntPtr.Zero,0,out len);
        IntPtr buf=Marshal.AllocHGlobal(len);
        if(!GetTokenInformation(token,1,buf,len,out len)) return null;
        TOKEN_USER tu=(TOKEN_USER)Marshal.PtrToStructure(buf, typeof(TOKEN_USER));
        StringBuilder n=new StringBuilder(256); StringBuilder d=new StringBuilder(256);
        int nl=256, dl=256, use=0;
        bool ok=LookupAccountSid(null,tu.User.Sid,n,ref nl,d,ref dl,out use);
        Marshal.FreeHGlobal(buf);
        return ok ? d.ToString()+"\\"+n.ToString() : null;
    }

    public static void RunAsUser(string targetUser, string Command)
    {
        string logPath=@"C:\Windows\Temp\results.log";
        string outputPath=@"C:\Windows\Temp\user_output.log";
        string scriptPath=@"C:\Windows\Temp\temp_user_script.ps1";

        using(StreamWriter w=new StreamWriter(logPath,true,Encoding.UTF8))
        {
            try
            {
                string wrapped="$ErrorActionPreference='Continue'\r\n"+
                "'===== START =====' | Out-File '"+outputPath+"' -Force\r\n"+
                "whoami | Out-File '"+outputPath+"' -Append\r\n" +
                "'===== END =====' | Out-File '"+outputPath+"' -Append\r\n";

                File.WriteAllText(scriptPath, wrapped, Encoding.UTF8);

                foreach(Process p in Process.GetProcessesByName("explorer"))
                {
                    IntPtr hp=OpenProcess(PROCESS_QUERY_INFORMATION,false,(uint)p.Id);
                    if(hp==IntPtr.Zero) continue;

                    IntPtr ht;
                    if(!OpenProcessToken(hp,TOKEN_DUPLICATE|TOKEN_ASSIGN_PRIMARY|TOKEN_QUERY,out ht)) continue;

                    string owner=GetUsernameFromToken(ht);
                    Log(w,"Token Owner: "+owner);

                    if(owner==null || !owner.EndsWith("\\"+targetUser,StringComparison.OrdinalIgnoreCase)) continue;

                    IntPtr dup;
                    if(!DuplicateTokenEx(ht,TOKEN_ALL_ACCESS,IntPtr.Zero,SecurityImpersonation,TokenPrimary,out dup))
                    {
                        Log(w,"DuplicateTokenEx failed: "+LastErr());
                        continue;
                    }

                    STARTUPINFO si=new STARTUPINFO();
                    si.cb=Marshal.SizeOf(si);
                    si.lpDesktop=@"winsta0\default";

                    PROCESS_INFORMATION pi;
                    string launch = "\"C:\\Windows\\System32\\cmd.exe\" /c " + Command +" > C:\\Windows\\Temp\\user_output.log ";

                    bool created=CreateProcessAsUser(dup,null,launch,IntPtr.Zero,IntPtr.Zero,false,CREATE_NO_WINDOW,IntPtr.Zero,null,ref si,out pi);

                    if(created)
                    {
                        Log(w,"CreateProcessAsUser succeeded. PID="+pi.dwProcessId);

                        uint wait=WaitForSingleObject(pi.hProcess,15000);
                        Log(w,"Wait Result="+wait);

                        uint exitCode;
                        if(GetExitCodeProcess(pi.hProcess,out exitCode))
                            Log(w,"Child Exit Code="+exitCode);

                        Log(w, File.Exists(outputPath) ? "user_output.log exists" : "user_output.log missing");
                    }
                    else
                    {
                        Log(w,"CreateProcessAsUser failed: "+LastErr());
                    }
					Log(w, "===== SCRIPT BEGIN =====");
					Log(w, File.ReadAllText(scriptPath));
					Log(w, "===== SCRIPT END =====");

                    try
                    {
                        if(File.Exists(scriptPath))
                        {
                            File.Delete(scriptPath);
                            Log(w,"temp_user_script.ps1 removed");
                        }
                    }
                    catch(Exception ex)
                    {
                        Log(w,"Cleanup failed: "+ex.Message);
                    }
                    return;
                }
            }
            catch(Exception ex)
            {
                File.AppendAllText(logPath, ex.ToString());
            }
        }
    }
}
"@

$Command = "COMMAND_HERE"
$targetUser = "TARGET_USER"
[UserTokenRunner]::RunAsUser($targetUser, $Command)
# Debug Logs stored:
# C:\Windows\Temp\results.log
# Command Output stored:
# C:\Windows\Temp\user_output.log 

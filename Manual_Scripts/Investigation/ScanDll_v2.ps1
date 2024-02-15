$csharpCode = @"
using System;
using System.Diagnostics;
using System.IO;
using System.Security.Principal;

public class DllScanner
{
    public static void ScanForDll(string dllKeyword)
    {
        string logPath = @"C:\windows\temp\results.log";

        using (StreamWriter writer = new StreamWriter(logPath, true))
        {
            writer.WriteLine("[+] Scanning DLLs...");

            // Check if running as administrator
            var principal = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            bool isAdmin = principal.IsInRole(WindowsBuiltInRole.Administrator);

            if (!isAdmin)
            {
                writer.WriteLine("[INFO] Running Scanner with limited privileges. This will restrict the scan results. Please run as administrator.");
            }

            foreach (Process process in Process.GetProcesses())
            {
                try
                {
                    foreach (ProcessModule module in process.Modules)
                    {
                        if (module.FileName.Contains(dllKeyword))
                        {
                            writer.WriteLine(string.Format("[+] Discovered Dependency: {0} on Process: {1}", module.FileName, process.ProcessName));
                        }
                    }
                }
                catch (Exception)
                {
                  
                }
            }
        }
    }
}
"@ 

Add-Type -TypeDefinition $csharpCode -Language CSharp
# Please make sure to enter the dll file you are searching for here
[dllscanner]::ScanForDll("MODULE_NAME.dll")
# The log file is written to C:\windows\temp\results.log

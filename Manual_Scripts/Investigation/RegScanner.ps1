$csharpCode = @"
using System;
using System.IO;
using System.Security;
using System.Security.Principal;
using Microsoft.Win32;
using System.Collections.Generic;

public class RegistryScanner
{
    public static void ScanRegistryForKeyword(string keyword)
    {
        string logPath = @"C:\windows\temp\registry_scan_results.log";
        using (StreamWriter writer = new StreamWriter(logPath, true))
        {
            writer.WriteLine("[+] Scanning Registry for keyword: " + keyword);

            var principal = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            bool isAdmin = principal.IsInRole(WindowsBuiltInRole.Administrator);

            if (!isAdmin)
            {
                writer.WriteLine("[INFO] Running Scanner with limited privileges. This may restrict the scan results. Please run as administrator.");
            }

            var keysToScan = new List<RegistryKey> { Registry.LocalMachine, Registry.Users };
            foreach(var key in keysToScan)
            {
                ScanRegistryKey(key, keyword, writer);
            }
        }
    }

	private static void ScanRegistryKey(RegistryKey root, string keyword, StreamWriter writer)
	{
		if (root == null) return;
		try
		{
			foreach (string subKeyName in root.GetSubKeyNames())
			{
   				// Skips SAM to avoid issues lol
				if (subKeyName.Equals("SAM", StringComparison.OrdinalIgnoreCase))
				{
					continue; 
				}

				try
				{
					using (RegistryKey subKey = root.OpenSubKey(subKeyName))
					{
						if (subKey != null)
						{
							if (subKey.Name.Contains(keyword))
							{
								writer.WriteLine("[+] Found keyword in key: " + subKey.Name);
							}

							foreach (var valueName in subKey.GetValueNames())
							{
								var value = subKey.GetValue(valueName);
								if (value != null)
								{
									if (valueName.Contains(keyword) || value.ToString().Contains(keyword))
									{
										writer.WriteLine("[+] Found keyword in value: " + subKey.Name + "\\" + valueName);
									}
								}
							}
							ScanRegistryKey(subKey, keyword, writer);
						}
					}
				}
				catch (SecurityException) { }
				catch (UnauthorizedAccessException) { }
				catch (IOException) { }
			}
		}
		catch (SecurityException) { }
		catch (UnauthorizedAccessException) { }
		catch (IOException) { }
	}
}
"@

Add-Type -TypeDefinition $csharpCode -Language CSharp
# Please make sure to enter the keyword reg keyword you are searching for.
[RegistryScanner]::ScanRegistryForKeyword("KEYWORD_HERE")
# The log file is written to C:\windows\temp\registry_scan_results.log

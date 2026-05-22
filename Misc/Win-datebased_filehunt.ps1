$SearchPath = "C:\"
$TargetDate = "05/22/2026"
$LogFile = "C:\Windows\Temp\hunter_log_results.log"

$Source = @"
using System;
using System.IO;
using System.Globalization;

public class FileHunter
{
    public static void Hunt(string searchPath, string targetDate, string logFile)
    {
        DateTime parsedDate;

        if (!DateTime.TryParseExact(
            targetDate,
            "MM/dd/yyyy",
            CultureInfo.InvariantCulture,
            DateTimeStyles.None,
            out parsedDate))
        {
            File.AppendAllText(
                logFile,
                "[ERROR] Invalid date format supplied: " + targetDate + Environment.NewLine
            );

            return;
        }

        File.AppendAllText(
            logFile,
            Environment.NewLine +
            "==============================" + Environment.NewLine +
            "[START] File Hunt Started: " + DateTime.Now.ToString() + Environment.NewLine +
            "[PATH] " + searchPath + Environment.NewLine +
            "[DATE] " + parsedDate.ToString("MM/dd/yyyy") + Environment.NewLine +
            "==============================" + Environment.NewLine
        );

        RecursiveSearch(searchPath, parsedDate, logFile);

        File.AppendAllText(
            logFile,
            "[END] File Hunt Completed: " + DateTime.Now.ToString() + Environment.NewLine
        );
    }

    private static void RecursiveSearch(string currentPath, DateTime targetDate, string logFile)
    {
        try
        {
            string[] files = Directory.GetFiles(currentPath);

            foreach (string file in files)
            {
                try
                {
                    FileInfo fi = new FileInfo(file);

                    if (fi.LastWriteTime.Date == targetDate.Date)
                    {
                        string logEntry =
                            "[MATCH] " +
                            fi.FullName +
                            " | LastWriteTime=" +
                            fi.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") +
                            " | Size=" +
                            fi.Length +
                            Environment.NewLine;

                        File.AppendAllText(logFile, logEntry);
                    }
                }
                catch (Exception ex)
                {
                    File.AppendAllText(
                        logFile,
                        "[FILE ERROR] " + file + " => " + ex.Message + Environment.NewLine
                    );
                }
            }

            string[] directories = Directory.GetDirectories(currentPath);

            foreach (string dir in directories)
            {
                RecursiveSearch(dir, targetDate, logFile);
            }
        }
        catch (Exception ex)
        {
            File.AppendAllText(
                logFile,
                "[DIR ERROR] " + currentPath + " => " + ex.Message + Environment.NewLine
            );
        }
    }
}
"@

Add-Type -TypeDefinition $Source -Language CSharp

[FileHunter]::Hunt(
    $SearchPath,
    $TargetDate,
    $LogFile
)

Get-Content $LogFile

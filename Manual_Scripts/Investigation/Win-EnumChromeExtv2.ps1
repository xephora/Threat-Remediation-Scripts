$username = "USERNAME"

if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\default") {
    $defaultExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\default\extensions" -r -fi "manifest.json" | % { $_.FullName})
    foreach ($extension in $defaultExtensions) {
        if (test-path $extension) {
            foreach ($dprofile in $extension) {
                $extid =  (($dprofile -split '\\extensions')[1] -split '\\')[1]
                $url = "https://chrome.google.com/webstore/detail/docs/"
                $eurl = "$($url)$($extid)"
                try {
                    $res = Invoke-WebRequest $eurl -ErrorAction Ignore
                    $content = $res.Content
                    $srange = $content.IndexOf("<title>")+"<title>".Length
                    $erange = $content.IndexOf("</title>")
                    $title = $content.Substring($srange,$erange - $srange)
                    "`nPath: $dprofile -> $title"
                } catch {
                    "`nPath: $dprofile ! Failed to detect!"
                }
            }
        }
    }
}

if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*") {
    $profiles = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*").Name
    foreach ($profile in $profiles) {
        if(test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile") {
            "`n[+] chrome profile $profile on profile $username"
            $ProfilesExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile\extensions" -r -fi "manifest.json" | % { $_.FullName})
            foreach ($cprofile in $ProfilesExtensions) {
                $extid =  (($cprofile -split '\\extensions')[1] -split '\\')[1]
                $url = "https://chrome.google.com/webstore/detail/docs/"
                $eurl = "$($url)$($extid)"
                try {
                    $res = Invoke-WebRequest $eurl -ErrorAction Ignore
                    $content = $res.Content
                    $srange = $content.IndexOf("<title>")+"<title>".Length
                    $erange = $content.IndexOf("</title>")
                    $title = $content.Substring($srange,$erange - $srange)
                    "`nPath: $cprofile -> $title"
                } catch {
                    "`nPath: $cprofile ! Failed to detect!"
                }
            }
        }
    }
}

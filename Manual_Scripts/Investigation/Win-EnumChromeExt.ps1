$users = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $users) {
	if ($user -notlike "*Public*") {
        $defaultprofileExists = test-path -path "C:\Users\$user\appdata\local\Google\chrome\User Data\default\extensions"
        if ($defaultprofileExists) {
            "`n[+] extensions on default profile $user"
            $defaultExtensions = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\default\extensions" -r -fi "manifest.json" | % { $_.FullName})
            foreach ($dprofile in $defaultExtensions) {
                "`nPath: $dprofile"
                $extcjson = cat "$dprofile"
                $extcjson | ForEach-Object {"$PSItem"}
            }
        }
        $profiles = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\Profile*").Name
        foreach ($profile in $profiles) {
            $profileExists = test-path -path "C:\Users\$user\appdata\local\Google\chrome\User Data\$profile"
            if ($profileExists) {
                "`n[+] chrome profiles on profile $user"
                $ProfilesExtensions = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\$profile\extensions" -r -fi "manifest.json" | % { $_.FullName})
                foreach ($cprofile in $ProfilesExtensions) {
                    "`nPath: $cprofile"
                    $extcjson = cat "$cprofile"
                    $extcjson | ForEach-Object {"$PSItem"}
                }
            }
        } 
    }
}

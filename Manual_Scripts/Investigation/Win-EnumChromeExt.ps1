# Uncomment extcjson to show manifest details for all extensions for target user

$user = "<username>"

if (test-path "C:\Users\$user\appdata\local\Google\chrome\User Data\default") {
    $defaultExtensions = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\default\extensions" -r -fi "manifest.json" | % { $_.FullName})
    foreach ($extension in $defaultExtensions) {
        if (test-path $extension) {
            foreach ($dprofile in $extension) {
                "`nPath: $dprofile"
                #$extcjson = cat "$dprofile"
                #$extcjson | ForEach-Object {"$PSItem"}
            }
        } 
    }
}

$profiles = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\Profile*").Name
foreach ($profile in $profiles) {
    if(test-path "C:\Users\$user\appdata\local\Google\chrome\User Data\$profile") {
        "`n[+] chrome profiles on profile $user"
        $ProfilesExtensions = @(gci "C:\Users\$user\appdata\local\Google\chrome\User Data\$profile\extensions" -r -fi "manifest.json" | % { $_.FullName})
        foreach ($cprofile in $ProfilesExtensions) {
            "`nPath: $cprofile"
            #$extcjson = cat "$cprofile"
            #$extcjson | ForEach-Object {"$PSItem"}
        }
    }
}

$username = "[USERNAME_HERE]"

$paths = @(
    "C:\Users\$username\.vscode\extensions",
    "C:\Users\$username\.vscode-insiders\extensions"
)

$results = @()

foreach ($path in $paths) {

    if (Test-Path $path) {

        $extensions = Get-ChildItem $path -Directory -ErrorAction SilentlyContinue

        foreach ($extension in $extensions) {

            $extensionName = $extension.Name

            $version = $null

            if ($extensionName -match '(?<name>.+)-(?<version>\d+\.\d+\.\d+.*)$') {

                $publisherAndName = $matches['name']
                $version = $matches['version']

            } else {

                $publisherAndName = $extensionName

            }

            $publisher = $null
            $name = $null

            if ($publisherAndName -match '^(?<publisher>[^\.]+)\.(?<name>.+)$') {

                $publisher = $matches['publisher']
                $name = $matches['name']

            } else {

                $name = $publisherAndName

            }

            $packageJson = Join-Path $extension.FullName "package.json"

            if (Test-Path $packageJson) {

                try {

                    $json = Get-Content $packageJson -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json

                    if ($json.publisher) {
                        $publisher = $json.publisher
                    }

                    if ($json.name) {
                        $name = $json.name
                    }

                    if ($json.version) {
                        $version = $json.version
                    }

                } catch {

                    "Failed to parse package.json for $($extension.FullName)"

                }

            }

            $results += [PSCustomObject]@{
                Username       = $username
                ExtensionName  = $name
                Publisher      = $publisher
                Version        = $version
                InstallPath    = $extension.FullName
            }

        }

    }

}

$results | Sort-Object Publisher, ExtensionName | ConvertTo-Json

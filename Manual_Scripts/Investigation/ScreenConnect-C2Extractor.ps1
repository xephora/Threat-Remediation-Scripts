$username = "USERNAME"
$screen_connect_configs = (gci "C:\Users\$username\AppData\Local\Apps\2.0" -r -fi "user.config" | % {$_.FullName})
foreach ($config in $screen_connect_configs) {
	$xmlent = [xml](Get-Content $config -ErrorAction SilentlyContinue)
	$valueNode = $xmlent.SelectSingleNode("//setting[@name='HostToAddressMap']/value")
	"File: $config`nC2: $($valueNode.InnerText)"
}

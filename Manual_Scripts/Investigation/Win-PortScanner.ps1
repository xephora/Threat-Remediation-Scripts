# Port scan a neighboring device using CrowdStrike.
"Company X is Performing Port Scan (Safe to Ignore)"
$ip = "ENTERIPHERE"
$ports = @(53,22,80,443,445,3389,5985)
foreach ($port in $ports) {
	$x = test-netconnection -ComputerName $ip -Port $port -InformationLevel "Detailed"
	if ($x.TcpTestSucceeded) {
		"$ip`:$port is reachable"
	}
}

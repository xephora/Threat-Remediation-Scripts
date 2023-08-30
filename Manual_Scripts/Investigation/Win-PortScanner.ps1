# Port scan a neighboring device using CrowdStrike.
"Company X is Performing Port Scan (Safe to Ignore)"
$ip = "ENTERIPHERE"
$ports = @(53,21,22,25,88,80,389,443,445,636,3389,5985)
foreach ($port in $ports) {
	$x = test-netconnection -ComputerName $ip -Port $port -InformationLevel "Detailed"
	if ($x.TcpTestSucceeded) {
		"$ip`:$port is reachable"
	}
}

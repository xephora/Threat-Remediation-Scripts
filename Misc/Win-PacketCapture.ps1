########################################
# Packet Capture script.
########################################

# Choose a directory to store the captures
# mkdir C:\temp
# cd C:\temp

# You can display current available network interfaces (Not necessary to run, but available)
# pktmon comp list

# To Add a packet capture filter by port, you can specify the protocol and port
# pktmon filter add -t udp -p 5678
# Optionally, you can choose both protocols
# pktmon filter add -p 5678

# Confirm if the filter was successfully added using the list command.
# pktmon filter list

# Start packet Capture
# pktmon start --capture

# Check the status of the capture
# pktmon status

# Finish your packet capture by stopping
# pktmon stop

# Convert your etl capture into a pcap
# pktmon etl2pcap .\file.etl -o output.pcap

# When finishing packet capturing, you can remove the filter
# pktmon filter remove

# Confirm the filter is removed after cleaning up
# pktmon filter list

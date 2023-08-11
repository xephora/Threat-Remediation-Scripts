################################################################################################################################################
# Experimental spray technique to hunt for browser hijacking websites. "ranges.txt" will need to contains a list of Digital Ocean CIDR blocks. #
################################################################################################################################################
import requests
import sys
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from concurrent.futures import ThreadPoolExecutor
import ipaddress

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

def scrape_scammers(target):
    url = f"http://{target}/windows/Win08AmpMeEr0887/index.html"
    print(f"[*] Testing: {url}..")
    try:
        res = requests.get(url, verify=False, timeout=1)
        if "Defender" in res.text:
            print(f"[+] Hit with URL: {url}. Dumping to log")
            with open("out.log", "w") as f:
                f.write(f"[*] URL: {url}\n{res.text}\n\n")
    except requests.RequestException as e:
        print(f"[!] Connection Failure for {ip}: {e}")

if __name__ == "__main__":
    # ranges.txt contains a list of CIDR blocks such as 192.168.1.0/24..192.168.2.0/24..etc
    with open("ranges.txt", "r") as f:
        targets = [line.strip() for line in f]

    all_ips = [str(ip) for ip_range in targets for ip in ipaddress.ip_network(ip_range)]

    with ThreadPoolExecutor(max_workers=3) as executor:
        executor.map(scrape_scammers, all_ips)

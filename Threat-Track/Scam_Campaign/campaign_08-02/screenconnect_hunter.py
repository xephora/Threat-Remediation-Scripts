##################################################################################################################  
# Usage: This script will quickly check a huge list of domains and determine if they run ScreenConnect server.   #
# Add the list of domains into a file named domains.txt and then make sure the scanner is in the same directory. #
##################################################################################################################
import requests
from threading import Thread

def check_url(domain):
    try:
        url = f"https://{domain}"
        response = requests.head(url, timeout=1)
        if 'ScreenConnect' in response.headers.get('server', ''):
            print(f"[+] hit: {url}")
    except requests.exceptions.RequestException:
        pass

with open('domains.txt', 'r') as file:
    domains = [line.strip() for line in file]

threads = []
for domain in domains:
    thread = Thread(target=check_url, args=(domain,))
    threads.append(thread)
    thread.start()

for thread in threads:
    thread.join()

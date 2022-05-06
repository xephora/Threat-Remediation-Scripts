###########################################################################
## A simple script to check exposed iControl REST API endpoint on BIG-IP ##
###########################################################################
# References
# https://threatpost.com/f5-critical-bugbig-ip-systems/179514/
# https://github.com/MrCl0wnLab/Nuclei-Template-CVE-2022-1388-BIG-IP-iControl-REST-Exposed
# https://support.f5.com/csp/article/K23605346
from requests import get
import sys
import warnings

warnings.filterwarnings('ignore', message='Unverified HTTPS request')

def checkVuln(target):
    # Adds vulnerable api endpoint to target url
    target = f"{target}/mgmt/shared/authn/login"
    # Makes a web request to target server
    res = get(target, verify=False)
    errorKeywords = ["resterrorresponse","message"]
    check = 0
    # Checks if response from web server returns a 401 status code
    if res.status_code == 401:
        check += 1
        # Checks if response page contains any identiable keywords.
        for i in errorKeywords:
            if i in res.text:
                check += 1
            else:
                pass
        # Performs a check if both criterias are met.
        if check == 3:
            return f"[+] Found an exposed iControl REST API => {target}"
    else:
        return "[!] Something went wrong with the request. Or server is not vulnerable."

if __name__ == "__main__":

    target = sys.argv[1]

    # Quick target check
    if target.endswith("/"):
        print("target url not formatted properly. Example: http://vulnerableserver")
        quit()
    else:
        pass

    if target.startswith("http"):
        pass
    else:
        print("target url not formatted properly. Example http://vulnerableserver")

    print(checkVuln(target))

### SolarMarker Backdoor Generator of redirectors

Generate a list of Solarmarker Backdoor redirectors for the purpose of blocking.  If the compromised site is taken down and if you find a different compromised site you can replace the site below with yours.

```python
import requests

def GenerateList(url):
        UList = []
        with open("urllist.txt", "w") as f:
                for i in range(1000):
                        resp = requests.get(url, allow_redirects=True)
                        genUrl = resp.text.split(";URL=")[1].split("\">")[0]
                        print(genUrl)
                        f.writelines(genUrl+"\n")
                        UList += genUrl

if __name__ == '__main__':
        url = "https://overadmit.site/Earthquakes-And-Seismic-Waves-Worksheet-Pearson-Education/pdf/sitedomen/8"
        print(GenerateList(url))
```

You can also supply a url as an argument as well. Example: Python3 GenerateList.py `https://somebadwebsite.site/Earthquakes-And-Seismic-Waves-Worksheet-Pearson-Education/pdf/sitedomen/8`

```python
import requests
import sys

def GenerateList(url):
        UList = []
        with open("urllist.txt", "w") as f:
                for i in range(1000):
                        resp = requests.get(url, allow_redirects=True)
                        genUrl = resp.text.split(";URL=")[1].split("\">")[0]
                        print(genUrl)
                        f.writelines(genUrl+"\n")
                        UList += genUrl

if __name__ == '__main__':
        url = sys.argv[1]
        print(GenerateList(url))
```

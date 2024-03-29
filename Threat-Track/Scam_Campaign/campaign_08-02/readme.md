## Observations

On August 2nd, 2023, I observed a series of browser-hijacking websites exhibiting similar patterns. All these websites were hosted on Digital Ocean and utilized similar endpoints, with slight variations. The threat actors routed these websites using Google Ad Services via a series of redirects. Both Google Tag Manager and the Chrome Omnibox also played a role. Chrome Omnibox interfaced with Google Ad Services and Google Tag Manager using tags. Each of these malicious websites would lock the browser and prompt an alert, forcing the victim to call a "support" phone number. Once engaged, unauthorized access was gained using RMM tools like AnyDesk, TeamViewer, or ConnectWise, often resulting in the theft of money.

### About Google Tag Manager:
https://support.google.com/tagmanager/answer/6102821?hl=en

### About Chrome Omnibox
https://developer.chrome.com/docs/extensions/reference/omnibox/

`/{generated}/win08rhmeer087/index.html`

```
67.205.135.25/4971/win08rhmeer087/index.html
198.199.70.76/1502/win08rhmeer087/index.html
162.243.162.25/1502/win08rhmeer087/index.html
104.248.60.22/3004/win08rhmeer087/index.html
147.182.142.182/3004/win08rhmeer087/index.html
157.230.81.17/3003/win08rhmeer087/index.html
147.182.140.206/1502/win08rhmeer087/index.html
67.205.149.45/3003/win08rhmeer087/index.html
137.184.210.236/3004/win08rhmeer087/index.html
192.81.211.166/3004/win08rhmeer087/index.html
157.230.232.167/3004/win08rhmeer087/index.html
157.245.252.168/1513/win08rhmeer087/index.html
167.99.233.150/4971/win08rhmeer087/index.html
142.93.13.104/4971/win08rhmeer087/index.html
67.207.93.205/4971/win08rhmeer087/index.html
198.199.74.98/3004/win08rhmeer087/index.html
143.198.172.101/1502/win08rhmeer087/index.html
137.184.220.164/4971/win08rhmeer087/index.html
137.184.30.20/1513/win08rhmeer087/index.html
165.22.9.103/1502/win08rhmeer087/index.html
137.184.74.177/3004/win08rhmeer087/index.html
147.182.189.219/4971/win08rhmeer087/index.html
142.93.207.86/3004/win08rhmeer087/index.html
142.93.252.103/4971/win08rhmeer087/index.html
147.182.187.74/4971/win08rhmeer087/index.html
68.183.122.78/4971/win08rhmeer087/index.html
68.183.18.131/1502/win08rhmeer087/index.html
165.22.12.163/1502/win08rhmeer087/index.html
159.203.189.208/4971/win08rhmeer087/index.html
157.245.253.207/4971/win08rhmeer087/index.html
206.189.228.114/4971/win08rhmeer087/index.html
143.198.116.19/4971/win08rhmeer087/index.html
162.243.174.165/4971/win08rhmeer087/index.html
142.93.123.143/1502/win08rhmeer087/index.html
142.93.193.196/1502/win08rhmeer087/index.html
198.199.70.206/3003/win08rhmeer087/index.html
161.35.123.174/1502/win08rhmeer087/index.html
137.184.208.128/4971/win08rhmeer087/index.html
167.172.150.86/4971/win08rhmeer087/index.html
204.48.18.132/3004/win08rhmeer087/index.html
204.48.26.154/4971/win08rhmeer087/index.html
137.184.222.7/3003/win08rhmeer087/index.html
146.190.214.141/4971/win08rhmeer087/index.html
146.190.214.44/4971/win08rhmeer087/index.html
24.199.94.232/4971/win08rhmeer087/index.html
162.243.173.80/4971/win08rhmeer087/index.html
147.182.216.211/1513/win08rhmeer087/index.html
159.89.49.184/3004/win08rhmeer087/index.html
208.68.37.55/3004/win08rhmeer087/index.html
68.183.133.224/1502/win08rhmeer087/index.html
157.230.60.87/3003/win08rhmeer087/index.html
198.211.96.228/4971/win08rhmeer087/index.html
157.230.3.157/4971/win08rhmeer087/index.html
162.243.166.100/1502/win08rhmeer087/index.html
165.22.182.121/1502/win08rhmeer087/index.html
142.93.11.254/1502/win08rhmeer087/index.html
157.230.53.147/7971/win08rhmeer087/index.html
67.205.183.6/4971/win08rhmeer087/index.html
204.48.26.216/3003/win08rhmeer087/index.html
134.209.120.60/4971/win08rhmeer087/index.html
159.223.141.164/4971/win08rhmeer087/index.html
147.182.142.246/4971/win08rhmeer087/index.html
142.93.149.65/3003/win08rhmeer087/index.html
162.243.166.48/1502/win08rhmeer087/index.html
142.93.3.252/7971/win08rhmeer087/index.html
159.223.189.152/4971/win08rhmeer087/index.html
206.189.182.181/4971/win08rhmeer087/index.html
137.184.76.234/1513/win08rhmeer087/index.html
159.65.234.26/3004/win08rhmeer087/index.html
67.205.135.32/4971/win08rhmeer087/index.html
206.189.181.141/3003/win08rhmeer087/index.html
137.184.52.171/3004/win08rhmeer087/index.html
138.197.146.6/3003/win08rhmeer087/index.html
138.197.153.62/3003/win08rhmeer087/index.html
159.89.92.81/4971/win08rhmeer087/index.html
167.172.129.76/1513/win08rhmeer087/index.html
64.227.14.54/3003/win08rhmeer087/index.html
157.230.8.73/4971/win08rhmeer087/index.html
134.122.126.5/4971/win08rhmeer087/index.html
167.99.230.78/3003/win08rhmeer087/index.html
159.223.148.55/4971/win08rhmeer087/index.html
165.227.41.238/3003/win08rhmeer087/index.html
167.99.1.57/3003/win08rhmeer087/index.html
142.93.126.189/4971/win08rhmeer087/index.html
159.203.3.227/3003/win08rhmeer087/index.html
159.223.121.186/1513/win08rhmeer087/index.html
138.197.158.3/3003/win08rhmeer087/index.html
138.197.148.131/3003/win08rhmeer087/index.html
159.203.35.209/3003/win08rhmeer087/index.html
157.245.244.135/4971/win08rhmeer087/index.html
167.99.14.163/3003/win08rhmeer087/index.html
137.184.23.107/1502/win08rhmeer087/index.html
159.203.10.93/1502/win08rhmeer087/index.html
159.223.96.64/4971/win08rhmeer087/index.html
159.223.136.237/4971/win08rhmeer087/index.html
134.122.121.227/4971/win08rhmeer087/index.html
134.209.78.117/4971/win08rhmeer087/index.html
134.209.78.225/4971/win08rhmeer087/index.html
206.189.183.115/1513/win08rhmeer087/index.html
165.227.198.7/1513/win08rhmeer087/index.html
142.93.57.173/4971/win08rhmeer087/index.html
174.138.36.117/4971/win08rhmeer087/index.html
204.48.26.43/3003/win08rhmeer087/index.html
157.230.185.50/4971/win08rhmeer087/index.html
157.245.245.194/4971/win08rhmeer087/index.html
134.122.115.204/4971/win08rhmeer087/index.html
165.227.43.78/3003/win08rhmeer087/index.html
159.65.227.229/3004/win08rhmeer087/index.html
137.184.96.25/3004/win08rhmeer087/index.html
206.81.13.193/1502/win08rhmeer087/index.html
159.223.177.103/4971/win08rhmeer087/index.html
142.93.126.241/4971/win08rhmeer087/index.html
159.223.118.106/3004/win08rhmeer087/index.html
137.184.16.231/3004/win08rhmeer087/index.html
67.205.161.198/3003/win08rhmeer087/index.html
147.182.133.150/3003/win08rhmeer087/index.html
138.197.147.68/3003/win08rhmeer087/index.html
46.101.19.126/windows/Win08AmpMeEr0887/index.html
165.232.96.216/windows/Win08AmpMeEr0887/index.html
206.189.19.51/windows/Win08AmpMeEr0887/index.html
159.65.59.3/virusdetect/Win08AmpMeEr0887/index.html
```

### Observed hijack messages

```
       <b>ACCESS TO THIS PC IS BLOCKED FOR SECURITY REASONS</b>
      </p>
      <p>Your computer has reported to us that it has been infected with Trojan-type spyware. The following data has been compromised.</p>
      <p>&gt; Email IDs <br>&gt; Bank passwords <br>&gt; Facebook logins <br>&gt; Photos and documents </p>
      <p>Windows Defender Scan has found a potentially unwanted adware on this device that can steal your passwords, your online identity, your financial information, your personal files, your photos or your documents.</p>
      <p>You should contact us immediately so that our engineers can guide you through the removal process by phone.</p>
      <p>Call Windows Support immediately to report this threat, prevent identity theft, and unblock access to this device.</p>
      <p>By closing this window, you are putting your personal information at risk and you may have your Windows registration suspended.</p>
      <p style="padding-bottom:0;color:#fff;font-size:16px">Call Windows Support: <strong>
          <span style="border:1px solid #fff;border-radius:5px;padding:2px 5px">+1-866-497-4732
```

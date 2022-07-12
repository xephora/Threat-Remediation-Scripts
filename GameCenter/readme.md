# My.com B.V GameCenter Unwanted Software remediation script

### Actions
- Terminates processes associated with GameCenter
- Remove GameCenter from the file system.
- Remove GameCenter registry keys.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I created an automated script to remove GameCenter.

### Why did I create a remediation script for My.com B.V GameCenter?

- GameCenter generates a large volume of connections overseas (CN,RU,NL,MY etc) which commonly trigger Antivirus/EDR solutions.
- GameCenter uses BitTorrent Protocol to share files via Peer-to-Peer (P2P).
- GameCenter has a built-in proxy that has the capability to bypass web filtering. 

### Dynamic Analysis:

https://app.any.run/tasks/081e2a4c-be59-4bf2-a8d8-5801e924c9ba?_gl=1*78w1d5*_ga*MTIwMDcyMzIzMy4xNjM0MzIyODA5*_ga_53KB74YDZR*MTY1NzYyNDg1OC40Mi4xLjE2NTc2MjQ5MjguNjA.&_ga=2.241184066.1342750788.1657624858-1200723233.1634322809/

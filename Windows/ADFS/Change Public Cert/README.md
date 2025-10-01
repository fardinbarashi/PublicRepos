<!-- ABOUT THE PROJECT -->
# About the Project

This repository is a step-by-step guide on how to update your **public SSL certificate** for ADFS and WAP servers.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

<!-- LICENSE -->
# License

Distributed under the **GPL-3.0 License**.  
See [`LICENSE.txt`](./LICENSE.txt) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

# 🖥️ On the ADFS Server

1. Import the new SSL certificate into the **Local Computer → Personal (MY)** certificate store.
2. Open an **elevated PowerShell** and get the thumbprint of the certificate:
   ```
   powershell : 
   cd cert:
   cd localmachine
   cd my
   dir
   ```
3. Identify the thumbprint in the output. 

4. Switch ADFS service communication certificate to the new SSL certificate with this cmdlet
   ```
   Set-AdfsCertificate -Thumbprint ThumbPrintNumber -CertificateType Service-Communications
   ```
5. Set the ADFS SSL certificate with this cmdlet and proof it with netsh
    ```
    Set-AdfsSslCertificate -Thumbprint ThumbPrintNumber 
    ```
6. Verifiy that the new SSL cert is in the ADFS-Apps
    ```
    netsh http show sslcert
    ```
7. Add read access to NT SERVICE\adfssrv
    ```
    1. Verifiy that NT SERVICE\adfssrv have read access on the certificate. 
	2. Open certlm.msc
	3. select the new SSL certificate
	4. select All Tasks / Manage private keys
	5. Add NT SERVICE\adfssrv
    6. Assign Read
    ```  
	
# 🌐 On the WAP Server :

1. Import the new SSL certificate in the computers MY certificate store.

2. Configure the WAP service for the new certificate with this cmdlet. 
    ```
		Set-WebApplicationProxySslCertificate -Thumbprint ThumbPrintNumber
	```
3. Rebuild Trust to ADFS.
    ```
		Install-WebApplicationProxy -CertificateThumbprint ThumbPrintNumber -FederationServiceName sts.youradfsservice.com
	```
4. ⚠️ OPTIONAL : Switch SSL certificate in WAP published applications.
   This step is missing in most documentations if you have existing WAP published applications.
   Since every published application is configured seperately with a SSL certificate we had to change every app.
   IF all apps in the infrastructure were published with the same certificate, switch all apps to the new certificate with this cmdlet: 
    ```
		Get-WebApplicationProxyApplication | Set-WebApplicationProxyApplication -ExternalCertificateThumbprint ThumbPrintNumber
	```
	





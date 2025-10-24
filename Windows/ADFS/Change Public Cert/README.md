<!-- ABOUT THE PROJECT -->
# About the Project

This repository is a step-by-step guide on how to update your **public SSL certificate** for ADFS and WAP servers.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---



# 🖥️ On the ADFS Server

1. Import the new SSL certificate into the **Local Computer → Personal (MY)** certificate store.
2. . Add read access to NT SERVICE\adfssrv
    ```
    1. Verifiy that NT SERVICE\adfssrv have read access on the certificate. 
	2. Open certlm.msc
	3. select the new SSL certificate
	4. select All Tasks / Manage private keys
	5. Add NT SERVICE\adfssrv
    6. Assign Read
    ```   


3. Open an **elevated PowerShell** and get the thumbprint of the certificate:
   ```
   powershell : 
   cd cert:
   cd localmachine
   cd my
   dir
   ```
4. Identify the thumbprint in the output.

5. Switch ADFS service communication certificate to the new SSL certificate with this cmdlet
   ```
   Set-AdfsCertificate -Thumbprint ThumbPrintNumber -CertificateType Service-Communications
   Restart-Service adfssrv
   ```
6. Set the ADFS SSL certificate with this cmdlet and proof it with netsh
    ```
    Set-AdfsSslCertificate -Thumbprint ThumbPrintNumber 
    ```
7. Verifiy that the new SSL cert is in the ADFS-Apps
    ```
    netsh http show sslcert
    ```
 
	
# 🌐 On the WAP Server :

1. Import the new SSL certificate in the computers MY certificate store.

2. Configure the WAP service for the new certificate with this cmdlet. 
    ```
		Set-WebApplicationProxySslCertificate -Thumbprint ThumbPrintNumber
	```
3. Rebuild Trust to ADFS.
    ```
		Install-WebApplicationProxy -CertificateThumbprint ThumbPrintNumber FederationServiceName 

		or

		$cred = Get-Credential
        Install-WebApplicationProxy `
        -FederationServiceName "sts.youradfsservice.com" `
        -CertificateThumbprint "ThumbPrintNumber" `
        -FederationServiceTrustCredential $cred

		
	```
4. ⚠️ OPTIONAL : Switch SSL certificate in WAP published applications.
   This step is missing in most documentations if you have existing WAP published applications.
   Since every published application is configured seperately with a SSL certificate we had to change every app.
   IF all apps in the infrastructure were published with the same certificate, switch all apps to the new certificate with this
   cmdlet: 
    ```
		Get-WebApplicationProxyApplication | Set-WebApplicationProxyApplication -ExternalCertificateThumbprint ThumbPrintNumber
	```


5. ⚠️ To remove old Cert if its bugging, 
Get Hostname

    ```
		netsh http show sslcert
    ```
    
Remove old cert	
```  	
		$RemoveCertThumbprint  = "ThumbPrintNumber"
        $app  = "{5d89a20c-beab-4389-9447-324788eb944a}"  # ADFS standard AppID

        # 0.0.0.0:443
        netsh http delete sslcert ipport=0.0.0.0:443 appid=$app

        # SNI-bindningar
        netsh http delete sslcert hostnameport=sts.youradfsservice.com:443
		certstorename=MY
        netsh http delete sslcert hostnameport=localhost:443
        netsh http delete sslcert hostnameport=sts.youradfsservice.com:49443
        netsh http delete sslcert hostnameport=enterpriseregistration.sts.youradfsservice.com:443

  ```

Add New cert	
```  
		
		$RemoveCertThumbprint  = "ThumbPrintNumber"
        $app  = "{5d89a20c-beab-4389-9447-324788eb944a}"  # ADFS standard AppID

        # 0.0.0.0:443
        netsh http add    sslcert ipport=0.0.0.0:443 certhash=$RemoveCertThumbprint appid=$app

        # SNI-bindningar
        netsh http add    sslcert hostnameport=sts.youradfsservice.com:443 certhash=$RemoveCertThumbprint appid=$app
		certstorename=MY

        netsh http add    sslcert hostnameport=localhost:443 certhash=$RemoveCertThumbprint appid=$app certstorename=MY

        netsh http add    sslcert hostnameport=sts.youradfsservice.com:49443 certhash=$RemoveCertThumbprint appid=$app
		certstorename=MY
		
        netsh http add    sslcert hostnameport=enterpriseregistration.sts.youradfsservice.com:443
		certhash=$RemoveCertThumbprint appid=$app certstorename=MY
```

<!-- LICENSE -->
# License

Distributed under the **GPL-3.0 License**.  
See [`LICENSE.txt`](./LICENSE.txt) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---










<!-- ABOUT THE PROJECT -->
# About The Project
This Repository's is a howto on change your public cert..

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
# License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>




# On the ADFS Server:

1. Import the new SSL certificate in the computers MY certificate store.
2. Run a elevated Powershell to get the thumbprint of the certificate.
    cd cert:
    cd localmachine
    cd my
    dir
3. Identify the thumbprint in the output. 

4. Switch ADFS service communication certificate to the new SSL certificate with this cmdlet
    Set-AdfsCertificate -Thumbprint ThumbPrint -CertificateType Service-Communications

5. Set the ADFS SSL certificate with this cmdlet and proof it with netsh
    Set-AdfsSslCertificate -Thumbprint ThumbPrint 

6. Verifiy that the new SSL cert is in the ADFS-Apps
    netsh http show sslcert

7. Add read access to NT SERVICE\adfssrv
    Verifiy that NT SERVICE\adfssrv have read access on the certificate. 
	Open certlm.msc
	select the new SSL certificate
	select All Tasks / Manage private keys
	Add NT SERVICE\adfssrv
    
	
	
	# On the WAP Server:

1. Import the new SSL certificate in the computers MY certificate store.

2. Configure the WAP service for the new certificate with this cmdlet. 
	Set-WebApplicationProxySslCertificate -Thumbprint ThumbPrint
	Install-WebApplicationProxy -CertificateThumbprint ThumbPrint -FederationServiceName sts.youradfsservice.com
	
	This step is missing in most documentations if you have existing WAP published applications. 
	Since every published application is configured seperately with a SSL certificate we had to change every app. 
	
3. IF all apps in the infrastructure were published with the same certificate, switch all apps to the new certificate with this cmdlet: 
	Get-WebApplicationProxyApplication | Set-WebApplicationProxyApplication -ExternalCertificateThumbprint ThumbPrint




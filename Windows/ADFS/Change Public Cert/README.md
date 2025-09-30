<!-- ABOUT THE PROJECT -->
# About The Project
This Repository's is a howto on change your public cert..

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
# License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>




On the ADFS Server:

    Import the new SSL certificate in the computers „MY“ certificate store.
    Run a elevated Powershell to get the thumbprint of the certificate.

    cd cert:
    cd localmachine
    cd my
    dir

    Identify the thumbprint in the output. In my case: 1E8B377DD54B7650612C98E4B8816501B4BB4985
    Switch ADFS service communication certificate to the new SSL certificate with this cmdlet

    Set-AdfsCertificate -Thumbprint 1E8B377DD54B7650612C98E4B8816501B4BB4985 -CertificateType Service-Communications

    Set the ADFS SSL certificate with this cmdlet and proof it with netsh

    Set-AdfsSslCertificate -Thumbprint 1E8B377DD54B7650612C98E4B8816501B4BB4985 

    netsh http show sslcert

    Verifiy that „read“ access for the ADFS service account was granted on the certificate. Open „certlm.msc“, select the new SSL certificate and select „All Tasks / Manage private keys“.
    Since this is a „Virtual Account“ we can see „NT SERVICE\adfssrv“ should have read access.
	
	
	
	
	On the WAP Server:

    Import the new SSL certificate in the computers „MY“ certificate store.
    Configure the WAP service for the new certificate with this cmdlet. 
	Set-WebApplicationProxySslCertificate -Thumbprint 1E8B377DD54B7650612C98E4B8816501B4BB4985
	Install-WebApplicationProxy -CertificateThumbprint 1E8B377DD54B7650612C98E4B8816501B4BB4985 -FederationServiceName sts.youradfsservice.com
	
	This step is missing in most documentations if you have existing WAP published applications. Since every published application is configured seperately with a SSL certificate we had to change every app. All applications in my infrastructure were published with the same certificate, so I’m able to switch all apps to the new certificate with this cmdlet: 

	Get-WebApplicationProxyApplication | Set-WebApplicationProxyApplication -ExternalCertificateThumbprint 1E8B377DD54B7650612C98E4B8816501B4BB4985

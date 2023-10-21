add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "-------------------"
Write-Host "------Test 1-------"
Write-Host "-------------------"
Write-Host "Pulling creds with spaces and custom file categories"

$baseURI = 'sbo3-sa01-pwa03.hosting.local'
$text = 'AppId=CredRetriever_Windows&Safe=S_KCH_Windows&Folder=Root&Username=cloud_win_api_svc&Address=kronoscloud.service-now.com'
$args = [uri]::EscapeUriString($text)
Write-host $args
Invoke-RestMethod -Uri "https://$baseURI/AIMWebService/api/Accounts?$args" -Method Get -ContentType "application/json"


# Eg. User name="admin", Password="admin" for this code sample.
$user = 'admin'
$pass = 'IjWI17lj/=Ta'

#$user = 'cloud_win_api_svc'
#$pass = 'Ukg@Kr0n05API'

$env = "dev127921"
#$env = "kronosclouddev"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
#RITM
$uri = "https://"+ $env + ".service-now.com/api/now/table/sc_req_item?sysparm_display_value=number%3DRITM0000001%2Ctrue&sysparm_limit=1"
#INC
#$uri = "https://"+ $env + ".service-now.com/api/now/table/incident?sysparm_display_value=number%3DINC0008111&sysparm_limit=1"

$method = "get"
$response = Invoke-RestMethod -Headers $headers -Method $method -Uri $uri 
$response.RawContent

Write-Host "$response"

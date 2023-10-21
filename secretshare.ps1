Clear-Host

#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-URL 
{
    param([Parameter(Mandatory=$false)][ValidatePattern("[01]")][int] $show=0,[Parameter(Mandatory=$true)][string] $password )

    $Body = @{
        grant_type = "client_credentials"
        client_id = "secretshare_workforce"
        client_secret = "VcMj0o5tEyFD4QfYR9MBOcJ4EVgQJevyGrWGhwA0n7dldMvHtFg6SddQn2XgIyVD"
    }
    $response = Invoke-RestMethod -Uri "https://sso.ukg.com:9031/as/token.oauth2" -Method Post -Body $Body
    $token = $response.access_token;
    if($show -eq 1) { Write-Host "token is :"$token  }

    $head = @{
        "Content-Type" = "application/json"
        "Authorization"= "Bearer $token"
    } 
    $body2 =  @"
        {
         "secret" :"$password",
         "password" :"",
         "hoursToLive" :"24",
         "recipients" :[
             {
                 "deliveryMethod" :"URL"
             }
         ],
         "public":true
     }
"@
    try
    {
       $result = Invoke-RestMethod -Uri "https://secretshare.ukg.com/api/v2/secrets" -Method Post -Headers $head -Body $body2 -ContentType "application/json" -UseBasicParsing
       if($show -eq 1) { $result }
       $out = $result.recipients 
       $URL = "https://secretshare.ukg.com/external/divulgences/"+$out.recipient
       if($show -eq 1) { Write-host "Go to URL:"$URL }
       return $URL;
    }
    catch
    {
        $msg = $_.Exception.Message
        if($show -eq 1) { $_.Exception.Response }
        Write-Warning("`n`t[$msg]")
        return $null;
    }

}

Get-URL -password "dummyPassword" -show 0


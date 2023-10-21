$file = Get-COntent -path C:\Users\PK32064\todisable.txt
foreach ($i in $file){
    Disable-ADAccount -Identity $i
    Set-ADUser -Identity $i -Description "Disabled as per #INC3776136"
    Get-ADUser $i -Properties samaccountName,Enabled | Select-Object Samaccountname,enabled  #Get AD Account 
    }

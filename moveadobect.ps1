

$computers = Get-Content C:\temp\test.txt

foreach ($comp in $computers) {

    Write-Host "##### $comp ####"
    Get-ADComputer $comp | Move-ADObject -TargetPath "OU=computer_objects,OU=Inactive_Accounts,dc=win,dc=mykronos,dc=com"
    Get-ADComputer $comp | Select-Object DistinguishedName

}

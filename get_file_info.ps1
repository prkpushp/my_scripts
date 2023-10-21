### Get All files name with path
#Get-ChildItem -Path 'C:\Users\pushparanjan.karn\OneDrive - UKG\Cloud.Windows' -Recurse | Select-Object FullName


Get-ChildItem -Path 'C:\Users\pushparanjan.karn\OneDrive - UKG\Cloud.Windows' -Recurse | Select-Object FullName | Export-csv test -NoTypeInformation

$a = Import-Csv .\test


$k = foreach ($file in $a){
    $filename = $file.FullName
    #Get-ItemProperty $file |Select-Object -Property *  | Select-Object FullName,CreationTime, LastWriteTime,@{N="Owner";E={ (Get-Acl $_.FullName).Owner }}
    #Write-Host "$filename"
    Get-ItemProperty $filename |Select-Object -Property *  | Select-Object FullName,CreationTime, LastWriteTime,@{N="Owner";E={ (Get-Acl $_.FullName).Owner }}

} 



$k | Export-Csv aa.csv -NoTypeInformation


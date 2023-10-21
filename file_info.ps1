### Get All files name with path
#Get-ChildItem -Path 'C:\Users\pushparanjan.karn\OneDrive - UKG\Cloud.Windows' -Recurse | Select-Object FullName

cd C:\allfiles
$files = dir 
#Write-Host "$files"
function get_last_modified($filepath){
    $date_modified = Get-Item $filepath | Foreach {$_.LastWriteTime}
    return $date_modified
    }
$hello = get_last_modified($filepath)

foreach ($file in $files){
    Get-ItemProperty $file |Select-Object -Property * | Select-Object FullName,CreationTime, LastWriteTime,@{N="Owner";E={ (Get-Acl $_.FullName).Owner }}
     
    #get-acl $file | Select-Object -Property * | Select-Object PSPath,PSDrive,Owner,Group,Access,Sddl,AccessToString,AuditToString 

} 




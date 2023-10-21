Filter AD Object of specific OU

Get-ADUser -Filter * -SearchBase "OU=Employees,OU=UserAccounts,dc=win,dc=mykronos,dc=com" -Properties Enabled | Where {$_.Enabled -like "False"} | FT SAMAccountName -AutoSize

Random Password Generator

-join ('abcdefghkmnrstuvwxyzABCDEFGHKLMNPRSTUVWXYZ23456789$%&*#'.ToCharArray() | Get-Random -Count 8)


Remove AD User without Prompt
Remove-ADUser -Identity username -Confirm:$False

get usrs all info:
net user username /domain |more


Rename AD Group:
Get-ADGroup -Identity 'test' | Rename-ADObject -NewName 'test1'
"""
Update ACL:
$myPath = 'C:\whatever.file'
# get actual Acl entry
$myAcl = Get-Acl "$myPath"
$myAclEntry = "Domain\User","FullControl","Allow"
$myAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($myAclEntry)
# prepare new Acl
$myAcl.SetAccessRule($myAccessRule)
$myAcl | Set-Acl "$MyPath"
# check if added entry present
Get-Acl "$myPath" | fl


Service Now Direct Login
https://kronosclouddev.service-now.com/side_door.do"""

###create AD User
$PASSWD = 'YOC=74-udoSa-4+0'
$ORG_UNIT = 'OU=Employees,OU=UserAccounts,DC=WIN,DC=mykronos,DC=com'
New-ADUser -Name "Aashish Saini" -GivenName Aashish -Surname Saini -SamAccountName AS45271 -UserPrincipalName AS45271@win.mykronos.com -employeeID 45271 -emailAddress aashish.saini@ukg.com -Description "Cloud Engineer" -Enabled  $true -path "$ORG_UNIT" -ChangePasswordAtLogon $false  -AccountPassword (ConvertTo-SecureString "$PASSWD" -AsPlainText -force) -passThru
Get-ADUser -Identity FK31928 -Properties Memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members AS45271


get-WmiObject win32_logicaldisk -Computername w01p01wf02-db03.int.prd.mykronos.com


Get Drives Windows GB
get-WmiObject win32_logicaldisk  -Computername w01p01wf02-db03.int.prd.mykronos.com | Format-Table DeviceId, MediaType,Size,FreeSpace /1GB

get-WmiObject win32_logicaldisk  -Computername w01p01wf02-db03.int.prd.mykronos.com  | Format-Table DeviceId, MediaType, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}


############## Find AD USer with specific String
Get-ADUser -Filter "name -like '$_'"

###Create AD Groups 
New-ADGroup -Name "$a" -SamAccountName "$a" -GroupCategory Security -GroupScope Global -DisplayName "$a" -Path "OU=UserGroups,DC=WIN,DC=mykronos,DC=com"


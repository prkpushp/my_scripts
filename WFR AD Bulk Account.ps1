$users = Import-Csv D:\users\PK32064\Downloads\abc.csv
$ORG_UNIT='OU=Employees,OU=UserAccounts,DC=WIN,DC=mykronos,DC=com'
function createpassword(){
    $password = -join ('abcdefghkmnrstuRSTUVWXYZ23456789$%&*#'.ToCharArray() | Get-Random -Count 16)
    return $password
}

function sendmail_steps(){
$smtpServer = "koss01-oss01-mta01-app.int.oss.mykronos.com"
$from="KCH Windows<kchwindows@mykronos.com>"
$subject = "Workforce Dimensions Logical Access Request #RITM0125333 - Active Directory Account  Created"
$bodymail  ="Hi $fname,

<p>As requested and approved by your manager, the provisioning of your Workforce Dimensions Logical Access Account (Active directory Domain Account) is now complete.<br>

<p>ID: $username <br>

<p>Password: will be sent in a separate e-maill.<br>
<p>Steps attached to log into the Windows environment.<br>
 
<p>Thanks <br>

<p>Cloud Windows Team<br>
"
Send-Mailmessage -smtpServer $smtpServer -from $from -to $email -subject $subject -Attachments 'C:\temp\How to Access WFR Windows Environment.pdf' -body $bodymail -bodyasHTML -priority High
}

function sendpasswd(){
    $smtpServer = "koss01-oss01-mta01-app.int.oss.mykronos.com"
    $from="KCH Windows<kchwindows@mykronos.com>"
    $subject = "Workforce Dimensions Logical Access Request #RITM0125333 - Active Directory Password"
    $bodypassword = "Hi $fname,<br>

    <p>Your AD Domain account password is: $passwd<br>
    <p>Please permanently delete this email immediately after securing the recieved password<br>
    <p>Thanks<br>
    <p>Cloud Windows Team<br>"

    Send-Mailmessage -smtpServer $smtpServer -from $from -to $email -subject $subject -body $bodypassword -bodyasHTML -priority High
}

foreach($user in $users){
    $username = $user.samaccountname
    $fname = $user.firstname
    $lname = $user.lastname
    $email = $user.email
    $empid = $user.empid
    $desc = $user.description
    $copy1 = $user.copy
    $passwd = createpassword
    Write-Host "$username $fname $lname $email $empid $desc $passwd $copy1 "
    New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -SamAccountName $username -UserPrincipalName $username@win.mykronos.com -employeeID $empid -emailAddress $email -Description "$desc" -Enabled  $true -path "$ORG_UNIT" -ChangePasswordAtLogon $false  -AccountPassword (ConvertTo-SecureString "$passwd" -AsPlainText -force) -passThru
    #Write-Host "New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -SamAccountName $username -UserPrincipalName $username@win.mykronos.com -employeeID $empid -emailAddress $email -Description "$desc" -Enabled  $true -path "$ORG_UNIT" -ChangePasswordAtLogon $false  -AccountPassword (ConvertTo-SecureString "$passwd" -AsPlainText -force) -passThru"
    sleep 2
    Get-ADUser -Identity $copy1 -Properties Memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $username
    sendmail_steps
    sendpasswd
}





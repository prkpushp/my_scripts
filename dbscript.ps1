
function UpdateStaticIP(){
    $NetworkInfo = Get-NetIPConfiguration 
    $IP_ADDR = $NetworkInfo.IPv4Address.IPAddress
    $ETHERNET_NAME = $NetworkInfo.InterfaceAlias
    $DEFAULT_GATEWAY = $NetworkInfo.IPv4DefaultGateway.NextHop
    echo "IP is:  $IP_ADDR"
    echo "Ethernet Alias is:  $ETHERNET_NAME "
    echo "Default Gateway is: $DEFAULT_GATEWAY"
    Write-Host "This command is going to be executed: " -NoNewline
    Write-Host "This command is going to be executed: netsh interface ip set address $ETHERNET_NAME static $IP_ADDR 255.255.255.240 $DEFAULT_GATEWAY" -ForegroundColor Yellow
    $YESNO = Read-Host "Please confirm if this looks Good(Y/N)"
    if ($YESNO -ilike "Y") {
        Write-Host "Updating Static IP"
        netsh interface ip set address $ETHERNET_NAME static $IP_ADDR 255.255.255.240 $DEFAULT_GATEWAY
    } elseif ($YESNO -ilike "N") {
        Write-Host "Aborting.."
    } else {
        Write-Host "Invalid input"
    }

}

function InstallClusterRole(){
Install-WindowsFeature Failover-Clustering -IncludeManagementTools
}

function GetRefInstance(){
    $InputString = "w01p01wf06-db08"
    $Delimiter = "-"
    $BaseHostname = $InputString.Split($Delimiter)[0] + "-"
    $StartIndex = 1
    $EndIndex = 10

    for ($i = $StartIndex; $i -le $EndIndex; $i++) {
        $Hostname = $BaseHostname + "db" + $i.ToString("00")
        $Response = Test-Connection -ComputerName $Hostname -Count 1 -Quiet

        if ($Response) {
            return $Hostname
            break  # Exit the loop once a positive result is found
        }
    }
}

function CreateUser(){

$SearchString = "sqladmin"
$Users = Get-WmiObject -Class Win32_UserAccount -ComputerName $RemoteComputer | Where-Object { $_.LocalAccount -eq $true -and $_.Name -like "*$SearchString*" }
$SQL_USER = $Users.Name
$Password = ConvertTo-SecureString -String "phLgl5W*_i8h8bevLt9igiTG" -AsPlainText -Force
New-LocalUser -Name "$SQL_USER" -Password $Password -FullName "SQL Admin User" -Description "SQL Admin Account" -UserMayNotChangePassword -PasswordNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member "$SQL_USER"

}

### need to check
function StartSQLLogonService(){
$serviceSQLServerName = "MSSQLSERVER"
$serviceSQLAgentName = "SQLSERVERAGENT"
$accountName = ".\test"
$accountPassword = ConvertTo-SecureString "phLgl5W*_i8h8bevLt9igiTG" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($accountName, $accountPassword)
$serviceSQLServer = Get-WmiObject -Class Win32_Service | Where-Object { $_.Name -eq $serviceSQLServerName }
$serviceSQLAgent = Get-WmiObject -Class Win32_Service | Where-Object { $_.Name -eq $serviceSQLAgentName }

if ($serviceSQLServer -ne $null) {
    $serviceSQLServer.Change($null, "Automatic", $null, $null, $null, $null, $accountName, $accountPassword)
    Write-Host "Logon user for service $serviceSQLServerName changed to $accountName, and startup type set to Automatic successfully."
} else {
    Write-Host "Service $serviceSQLServerName not found."
}

if ($serviceSQLAgent -ne $null) {
    $serviceSQLAgent.Change($null, "Automatic", $null, $null, $null, $null, $accountName, $accountPassword)
    Write-Host "Logon user for service $serviceSQLAgentName changed to $accountName, and startup type set to Automatic successfully."
} else {
    Write-Host "Service $serviceSQLAgentName not found."
}


}


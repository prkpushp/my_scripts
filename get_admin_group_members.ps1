 Get-ADGroup -Filter {Name -like "*admin123*"} | Select-Object SamAccountName > C:\temp\all_admin_groups.txt
$all_rdp_groups = Get-ADGroup -Filter {Name -like "*admin*"} | Select-Object SamAccountName

$csvData = @()

foreach ($group in $all_rdp_groups) {
    $groupMembers = Get-ADGroupMember -Identity $group.SamAccountName | Select-Object SamAccountName
    $groupMembers | ForEach-Object {
        $csvData += [PSCustomObject]@{
            GroupName = $group.SamAccountName
            MemberName = $_.SamAccountName
        }
    }
}

$csvData | Export-Csv -Path "C:\temp\GroupMembers.csv" -NoTypeInformation

#From above filter out persona conatining onesupport, engineering, cis

function Get-PersonaVsUser {
$adGroups = @(
"onesupport-L3-platform",
    "onesupport-L4-dba",
    "engineering-L3-hcmdevops",
    "onesupport-L3-dba",
    "onesupport-L3-wfrdba",
    "onesupport-L2-platform",
    "onesupport-L4-platform",
    "onesupport-L3-tools",
    "onesupport-L4-tools",
    "onesupport-L3-network",
    "onesupport-L4-network",
    "onesupport-L3-security",
    "onesupport-L4-security",
    "onesupport-L5-platform",
    "engineering-L4-hcmdevops",
    "engineering-L5-hcmdevops",
    "onesupport-L3-automation",
    "onesupport-L4-automation",
    "engineering-L3-wfrdevops",
    "engineering-L4-wfrdevops",
    "onesupport-L2-WFRplatform",
    "onesupport-L3-WFRplatform",
    "onesupport-L2-wfrdba",
    "cis-L3-secanalyst",
    "onesupport-L3-ebnplatform",
    "onesupport-L4-ebnplatform",
    "onesupport-L3-bnkprofsvc",
    "onesupport-L4-bnkprofsvc",
    "onesupport-L5-bnkprofsvc",
    "onesupport-L3-bnkdevops",
    "onesupport-L4-bnkdevops",
    "onesupport-L5-bnkdevops",
    "onesupport-L3-bnkplatform",
    "onesupport-L4-bnkplatform",
    "onesupport-L5-bnkplatform",
    "engineering-L3-bnkdevops",
    "engineering-L4-bnkdevops",
    "engineering-L5-bnkdevops",
    "engineering-L3-bnkswdeveloper",
    "engineering-L4-bnkswdeveloper",
    "engineering-L5-bnkswdeveloper",
    "engineering-L3-csedevops",
    "onesupport-l3-platformsre",
    "onesupport-l4-platformsre",
    "engineering-L4-csedevops",
    "engineering-L2-csedevops",
    "engineering-L5-cseswdeveloper",
    "engineering-L4-cseswdeveloper",
    "engineering-L3-cseswdeveloper",
    "engineering-L2-cseswdeveloper",
    "engineering-L5-csedevops",
    "onesupport-L3-dataops"
)

$csvData = @()

foreach ($group in $adGroups) {
    $groupMembers = Get-ADGroupMember -Identity $group | Select-Object SamAccountName
    $groupMembers | ForEach-Object {
        $csvData += [PSCustomObject]@{
            GroupName = $group
            MemberName = $_.SamAccountName
        }
    }
}

$csvData | Export-Csv -Path "C:\temp\persona_vs_user.csv" -NoTypeInformation


}

Get-PersonaVsUser

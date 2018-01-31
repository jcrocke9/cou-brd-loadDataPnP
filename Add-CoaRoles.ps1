#region: Logging Start
$logLineTime = (Get-Date).ToString() 
$logFileDate = Get-Date -UFormat "%Y%m%d"
$logLineInfo = "`t$([Environment]::UserName)`t$([Environment]::MachineName)`t"
$logCode = "Start"
$writeTo = "Starting Import Script for Roles"
$logLine = $null
function WriteToLog {
    param([string]$logLineTime, [string]$writeTo, [string]$logCode)
    $logLine = $logLineTime
    $logLine += $logLineInfo
    $logLine += $logCode; $logLine += "`t"
    $logLine += $writeTo
    $logLine | Out-File -FilePath "C:\logs\BCApp1_$logFileDate.log" -Append -NoClobber
    Clear-Variable logLine -Scope global
    Clear-Variable writeTo -Scope global
    Clear-Variable logLineTime -Scope global
    Clear-Variable logCode -Scope global
}
# WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
#endregion
function Get-CoaCommiItem {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$ListItemTitle
    )
    $ListItemData = Get-PnPListItem -List Commissions -Query "<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$ListItemTitle</Value></Eq></Where></Query></View>"
    Write-Output $ListItemData
    Clear-Variable ListItemData
}
function Add-CoaRoles {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$FilePath
    )
    class Role {
        [string]$Commission
        [string]$Vote
        [string]$Type
        [string]$Member
    }
    $rolesArr = [System.Collections.Generic.List[System.Object]]::new();
    Import-Csv -Path $FilePath | ForEach-Object {
        $role = [Role]::new()
        $role.Commission = $_.Commission
        $role.Vote = $_.Vote
        $role.Type = $_.Type
        $role.Member = $_.Member
        $rolesArr.Add($role);
    }
    $writeTo = "Finished importing roles data with " + $rolesArr.Count 
    $logCode = "Success"
    $logLineTime = (Get-Date).ToString()
    WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
    pause
    $rolesArr | foreach-object {
        $roleItem = Add-PnPListItem -List Roles -Values @{
            "Title" = $_.Member;
            "roleType" = $_.Type;
        }
        if ($_.Commission) {
            $commiLookup = Get-CoaCommiItem -ListItemTitle $_.Commission
            $commiLookupId = $commiLookup.Id;
            Set-PnPListItem -List Roles -Identity $roleItem.Id -Values @{
                "roleCommi" = $commiLookupId;
            }
        }
        Clear-Variable commiLookup;
        Clear-Variable commiLookupId;
        if ($_.roleVote -eq "Yes") {
            $roleVote = 1
            Set-PnPListItem -List Roles -Identity $roleItem.Id -Values @{
                "roleVote" = $roleVote;
            }
        } elseif ($_.roleVote -eq "No") {
            $roleVote = 0
            Set-PnPListItem -List Roles -Identity $roleItem.Id -Values @{
                "roleVote" = $roleVote;
            }
        }
    }
}
function Set-CoaRolesFields {
    Add-PnPField -DisplayName "Role of Appointee" -InternalName "roleChoice" -Type "Text" -Group "Role"
    Add-PnPFieldToContentType -Field "roleChoice" -ContentType "Role"
}
function Add-CoaRolesWithCommissions {
    $i = 0
    Get-PnPListItem -List Roles -Fields "Title","roleCommi" | ForEach-Object {
        $index = $i++
        $title = $_["Title"];
        $commission = $_["roleCommi"].LookupValue
        $newFieldValue = $commission + " | " + $title + " " + $index
        $newFieldValue
        $itemId = $_.Id;
        Set-PnPListItem -List "Roles" -Identity $itemId -Values @{"roleChoice" = $newFieldValue}
        Clear-Variable title;
        Clear-Variable commission;
        Clear-Variable newFieldValue;
    }
}
function Add-CoaAppointmentToRole {
    Add-PnPFieldToContentType -Field "roleApte" -ContentType "Role"
}

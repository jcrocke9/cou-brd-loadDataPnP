Import-Module SharePointPnPPowerShellOnline  -NoClobber
#region: Logging Start
$logLineTime = (Get-Date).ToString() 
$logFileDate = Get-Date -UFormat "%Y%m%d"
$logLineInfo = "`t$([Environment]::UserName)`t$([Environment]::MachineName)`t"
$logCode = "Start"
$writeTo = "Starting Import Script"
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
WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
#endregion

function Connect-CoaPnpSite {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$Url
    )
    $creds = Get-Credential
    Connect-PnPOnline -Url $url -Credentials $creds
    Clear-Variable Url
    Clear-Variable creds
}

#region: Commission
class Commission {
    [string]$Commission
    [string]$Totmembers	
    [string]$Description
    [string]$YEARTERM
    [string]$MBERCOMMT
    [string]$CITYSTAFF
}

$commissionsArr = [System.Collections.Generic.List[System.Object]]::new();

function Import-CoaCsv {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$FilePath
    )
    Import-Csv -Path $FilePath | ForEach-Object {
        $commission = [Commission]::new()
        $commission.Commission = $_.COMMISSION
        $commission.Totmembers = $_.Totmembers
        $commission.Description = $_.Description
        $commission.YEARTERM = $_.YEARTERM
        $commission.MBERCOMMT = $_.MBERCOMMT
        $commission.CITYSTAFF = $_.CITYSTAFF
        $commissionsArr.Add($commission)
    }
    Clear-Variable FilePath
    Add-CoaPnpListItem
}

function Add-CoaPnpListItem {
    $commissionsArr | ForEach-Object {
        Add-PnPListItem -List "Commissions" -Values @{
            "Title"             = $_.Commission;
            "commiTotalMembers" = $_.Totmembers;
            "commiDesc"         = $_.Description;
            "commiTerm"         = $_.YEARTERM;
            "commiMberCommt"    = $_.MBERCOMMT;
            "commiCityStaff1"   = $_.CITYSTAFF;
        }
    }
}
#endregion

#region: Appointee
class Appointee {
    [string]$LastName
    [string]$FirstName
    [string]$FullName
    [string]$Archive
    [string]$Commission
    [string]$MemberType
    [string]$MemberType2
    [string]$StreetNumber
    [string]$StreetName
    [string]$City
    [string]$State
    [string]$Zip
    [string]$EMail
    [string]$HomePh
    [string]$Businessph
    [string]$Fax
    [string]$Occupation
    [string]$Occupation2
    [string]$Occupation3
    [string]$StartDate
    [string]$EndDate
    [string]$TemExpired
    [string]$OriginalDate
    [string]$Oath
    [string]$DateTaken
    [string]$Chairman
    [string]$Comments
    [string]$Delete
    [string]$DeletedWhen
    [string]$DeletedBy
}
$appointeesArr = [System.Collections.Generic.List[System.Object]]::new();
$appointmentArr = [System.Collections.Generic.List[System.Object]]::new();
function Import-CoaCsvAppointee {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$FilePath
    )
    Import-Csv -Path $FilePath | ForEach-Object {
        $appointee = [Appointee]::new()
        $temLastName = $_.LastName
        $appointee.LastName = $temLastName.Trim()
        $temFirstName = $_.FirstName
        $appointee.FirstName = $temFirstName.Trim()
        $appointee.FullName = $temFirstName.Trim() + " " + $temLastName.Trim()
        Clear-Variable temFirstName
        Clear-Variable temLastName;
        $appointee.Archive = $_.Archive
        $appointee.Commission = $_.Commission
        $appointee.MemberType = $_.MemberType + " " + $_.MemberType2
        $appointee.StreetName = $_.StreetNumber + " " + $_.StreetName
        $appointee.City = $_.City
        $appointee.State = $_.State
        $appointee.Zip = $_.Zip
        $appointee.EMail = $_."E-mail"
        $appointee.HomePh = $_."Home-Ph"
        $appointee.Businessph = $_."Business-ph"
        $appointee.Fax = $_.Fax
        $appointee.Occupation = $_.Occupation + " " + $_.Occupation2 + " " + $_.Occupation3
        $appointee.StartDate = $_.StartDate
        $appointee.EndDate = $_.EndDate
        $appointee.TemExpired = $_.TemExpired
        $appointee.OriginalDate = $_.OriginalDate
        $appointee.Oath = $_.Oath
        $appointee.DateTaken = $_.DateTaken
        $appointee.Chairman = $_.Chairman
        $appointee.Comments = $_.Comments
        $appointee.Delete = $_.Delete
        $appointee.DeletedWhen = $_.DeletedWhen
        $appointee.DeletedBy = $_.DeletedBy
        if (!$appointeesArr.Exists( {param($a) $a.FullName -eq $appointee.FullName})) {            
            $appointeesArr.Add($appointee);
        }
        $appointmentArr.Add($appointee);
    }
    $writeTo = "Finished importing appointee data with " + $appointeesArr.Count + " and " + $appointmentArr.Count
    $logCode = "Success"
    $logLineTime = (Get-Date).ToString()
    WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
    pause
    # Add-CoaPnpListItemAppointee
    Add-CoaPnpListItemAppointment
}

function Add-CoaPnpListItemAppointee {
    $appointeesArr | ForEach-Object {
        Add-PnPListItem -List Appointees -Values @{
            "Title"         = $_.LastName;
            "FirstName"     = $_.FirstName;
            "FullName"      = $_.FullName;
            "WorkAddress"   = $_.StreetName;
            "WorkCity"      = $_.City;
            "WorkState"     = $_.State;
            "WorkZip"       = $_.Zip;
            "EMail"         = $_.EMail;
            "HomePhone"     = $_.HomePh;
            "WorkPhone"     = $_.Businessph;
            "WorkFax"       = $_.Fax;
            "Company"       = $_.Occupation;
        }
    }
    $writeTo = "Finished exporting all appointees"
    $logCode = "Success"
    $logLineTime = (Get-Date).ToString()
    WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
    Pause
    Add-CoaPnpListItemAppointment
}
function Add-CoaPnpListItemAppointment {
    $appointmentArr | ForEach-Object {
        $boardsItem = Add-PnPListItem -List Appointments -Values @{
            "Title" = $_.MemberType;
            "atmDesc"      = $_.Comments;
        }
        if ($_.Oath -eq "TRUE") {
            $atmOath = 1
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmOath" = $atmOath; # appointment
            } 
        } else {
            $atmOath = 0
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmOath" = $atmOath;
            } 
        }
        Clear-Variable atmOath
        <# if ($_.Archive -eq "TRUE") {
            $atmArchive = 1
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmArchive" = $atmArchive; # appointment
            }
        } else {
            $atmArchive = 0
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmArchive" = $atmArchive;
            }
        }
        Clear-Variable atmArchive; #>
        if ($_.Chairman -eq "TRUE") {
            $atmChairman = 1
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmChairman" = $atmChairman; # appointment
            }
        } else {
            $atmChairman = 0
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmChairman" = $atmChairman;
            }
        }
        Clear-Variable atmChairman; 
        <# if ($_.Delete -eq "TRUE") {
            $atmDelete = 1;
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmDelete" = $atmDelete;
            }
        } else {
            $atmDelete = 0;
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmDelete" = $atmDelete; # appointment
            }
        }
        Clear-Variable atmDelete; #>
        if ($_.StartDate) {
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmStartDate" = $_.StartDate; # appointment
            }
        }
        if ($_.EndDate) {
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmEndDate" = $_.EndDate; # appointment
            }
        }
        if ($_.OriginalDate) {
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmOriginalDate" = $_.OriginalDate; # appointment
            }
        }
        if ($_.DateTaken) {
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmDateTaken" = $_.DateTaken; # appointment
            }
        }
        <# if ($_.DeletedWhen) {
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmDeletedDate" = $_.DeletedWhen; # appointment
            }
        } #>
        if ($_.Commission) {
            $commiLookup = Get-CoaCommiItem -ListItemTitle $_.Commission
            $commiLookupId = $commiLookup.Id;
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmCommi" = $commiLookupId; # appointment
            }
        }
        Clear-Variable commiLookup;
        Clear-Variable commiLookupId;
        if ($_.FullName) {
            $appteeLookup = Get-CoaAppteeItem -ListItemTitle $_.FullName
            $appteeLookupId = $appteeLookup.Id;
            Set-PnPListItem -List Appointments -Identity $boardsItem.Id -Values @{
                "atmAppointee" = $appteeLookupId; # appointment
            }
        }
        Clear-Variable appteeLookup;
        Clear-Variable appteeLookupId;
    }
    $writeTo = "Finished exporting all appointments"
    $logCode = "Success"
    $logLineTime = (Get-Date).ToString()
    WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
}

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
function Get-CoaAppteeItem {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$ListItemTitle
    )
    $ListItemData = Get-PnPListItem -List Appointees -Query "<View><Query><Where><Eq><FieldRef Name='FullName'/><Value Type='Text'>$ListItemTitle</Value></Eq></Where></Query></View>"
    Write-Output $ListItemData
    Clear-Variable ListItemData
}
#endregion

function Start-CoaBCAppImport {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$Url,
        [parameter(Mandatory = $true)]
        [String]$FilePath,
        [parameter(Mandatory = $true)]
        [ValidateSet("Commission", "Appointee")]
        [String]$List
    )
    try {
        Connect-CoaPnpSite -Url $Url
        $writeTo = "Connected to $Url"
        $logCode = "Success"
        $logLineTime = (Get-Date).ToString()
        WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
    }
    catch {
        Write-Output "Error connecting"
        $writeTo = "Unable to connect to $Url"
        $logCode = "Error"
        $logLineTime = (Get-Date).ToString()
        WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
        return;
    }
    switch ($List) {
        "Commission" { Import-CoaCsv -FilePath $FilePath; break; }
        "Appointee" { 
            Import-CoaCsvAppointee -FilePath $FilePath;
            break;
        }
    }
    $writeTo = "Exiting CoaBCAppImport"
    $logCode = "Success"
    $logLineTime = (Get-Date).ToString()
    WriteToLog -logLineTime $logLineTime -writeTo $writeTo -logCode $logCode
}
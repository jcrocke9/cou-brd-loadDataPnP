Import-Module SharePointPnPPowerShellOnline  -NoClobber

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
    [string]$Archive
    [string]$Commission
    [string]$MemberType
    [string]$MemberType2
    [string]$StreetNumber
    [string]$StreetName
    [string]$City
    [string]$State
    [string]$Zip
    [string]$Email
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

function Import-CoaCsvAppointee {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$FilePath
    )
    Import-Csv -Path $FilePath | ForEach-Object {
        $appointee = [Appointee]::new()
        $appointee.LastName = $_.LastName
        $appointee.FirstName = $_.FirstName
        $appointee.Archive = $_.Archive
        $appointee.Commission = $_.Commission
        $appointee.MemberType = $_.MemberType + " " + $_.MemberType2
        $appointee.StreetName = $_.StreetNumber + " " + $_.StreetName
        $appointee.City = $_.City
        $appointee.State = $_.State
        $appointee.Zip = $_.Zip
        $appointee.Email = $_."E-mail"
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
        $appointeesArr.Add($appointee);
    }
}

function Add-CoaPnpListItemAppointee {
    $appointeesArr | ForEach-Object {
        $boardsItem = Add-PnPListItem -List Appointee -Values @{
            "Title"            = $_.LastName;
            "FirstName"        = $_.FirstName;
            "boardsMemberType" = $_.MemberType;
            "WorkAddress"      = $_.StreetName;
            "WorkCity"         = $_.City;
            "WorkState"        = $_.State;
            "WorkZip"          = $_.Zip;
            "Email"            = $_.Email;
            "HomePhone"        = $_.HomePh;
            "WorkPhone"        = $_.Businessph;
            "WorkFax"          = $_.Fax;
            "Company"          = $_.Occupation;
            "boardsDeletedBy"  = $_.DeletedBy;
            "boardsDesc"       = $_.Comments;

        }
        if ($_.Oath -eq "TRUE") {
            $boardsOath = $true
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsOath" = $boardsOath;
            } 
        }
        else {
            $boardsOath = $false
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsOath" = $boardsOath;
            } 
        }
        Clear-Variable boardsOath
        if ($_.Archive -eq "TRUE") {
            $boardsArchive = $true
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsArchive" = $boardsArchive;
            }
        }
        else {
            $boardsChairman = $false
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsArchive" = $boardsArchive;
            }
        }
        Clear-Variable boardsArchive;
        if ($_.Chairman -eq "TRUE") {
            $boardsChairman = $true
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsChairman" = $boardsChairman;
            }
        }
        else {
            $boardsChairman = $false
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsChairman" = $boardsChairman;
            }
        }
        Clear-Variable boardsChairman; 
        if ($_.Delete -eq "TRUE") {
            $boardsDelete = $true;
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsDelete" = $boardsDelete;
            }
        }
        else {
            $boardsDelete = $false;
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsDelete" = $boardsDelete;
            }
        }
        Clear-Variable boardsDelete;

        if ($_.StartDate) {
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsStartDate" = $_.StartDate;
            }
        }
        if ($_.EndDate) {
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsEndDate" = $_.EndDate;
            }
        }
        if ($_.OriginalDate) {
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsOriginalDate" = $_.OriginalDate;
            }
        }
        if ($_.DateTaken) {
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsDateTaken" = $_.DateTaken;
            }
        }
        if ($_.DeletedWhen) {
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsDeletedDate" = $_.DeletedWhen;
            }
        }
        if ($_.Commission) {
            $commiLookup = Get-CoaCommiItem -ListItemTitle $_.Commission
            $commiLookupId = $commiLookup.Id;
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsCommi" = $commiLookupId;
            }
        }
        Clear-Variable commiLookup;
        Clear-Variable commiLookupId;
    }
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

Import-CoaCsvAppointee -FilePath C:\Users\jcroc\Documents\Appointee.csv
Add-CoaPnpListItemAppointee
#endregion

function Start-CoaCommiImport {
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
    }
    catch {
        Write-Output "Error connecting"
        return;
    }
    switch ($List) {
        "Commission" { Import-CoaCsv -FilePath $FilePath; break; }
        "Appointee" { 
            Import-CoaCsvAppointee -FilePath $FilePath;
            Add-CoaPnpListItemAppointee;
            break;
        }
    }
}
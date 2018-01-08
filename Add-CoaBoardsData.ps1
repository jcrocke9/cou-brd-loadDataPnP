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
    Import-Csv -Path $FilePath | foreach {
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
    $commissionsArr | foreach {
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
    Import-Csv -Path $FilePath | foreach {
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
    $appointeesArr | foreach {
        if ($_.Commission) {
            $commiLookup = Get-CoaCommiItem -ListItemTitle $_.Commission
            $commiLookupId = $commiLookup.Id;
            if ($_.Archive -eq "TRUE") {
                $boardsArchive = $true
            }
            else {
                $boardsArchive = $false
            }
            if ($_.Oath -eq "TRUE") {
                $boardsOath = $true
            }
            else {
                $boardsOath = $false
            }
            if ($_.Chairman -eq "TRUE") {
                $boardsChairman = $true
            }
            else {
                $boardsChairman = $false
            }
            $boardsItem = Add-PnPListItem -List Appointee -Values @{
                "Title" = $_.LastName;
                "FirstName" = $_.FirstName;
                "boardsArchive" = $boardsArchive;
                "boardsMemberType" = $_.MemberType;
                "WorkAddress" = $_.StreetName;
                "WorkCity" = $_.City;
                "WorkState" = $_.State;
                "WorkZip" = $_.Zip;
                "Email" = $_.Email;
                "HomePhone" = $_.HomePh;
                "WorkPhone" = $_.Businessph;
                "WorkFax" = $_.Fax;
                "Company" = $_.Occupation;
                "boardsStartDate" = $_.StartDate;
                "boardsOriginalDate" = $_.OriginalDate;
                "boardsDateTaken" = $_.DateTaken;
            } 
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsCommi"   = $commiLookupId;
            }
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsOath"   = $boardsOath;
            }
            Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                "boardsChairman"   = $boardsChairman;
            }
            if ($_.EndDate) {
                Set-PnPListItem -List Appointee -Identity $boardsItem.Id -Values @{
                    "boardsEndDate" = $_.EndDate;
                }
            }
            clv commiLookup;
            clv commiLookupId;
            clv boardsOath;
            clv boardsArchive;
            clv boardsChairman;
        }
        else {
            Add-PnPListItem -List Appointee -Values @{
                "Title"     = $appointee.LastName;
                "FirstName" = $appointee.FirstName;
            }
        }
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

Import-CoaCsvAppointee -FilePath "C:\alex\Appointee.csv"
Add-CoaPnpListItemAppointee

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
        "Commission" { } # Import-CoaCsv -FilePath $FilePath; break; }
        "Appointee" { Get-CoaCommiItem }
    }
}
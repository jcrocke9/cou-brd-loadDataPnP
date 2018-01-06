class Commission {
    [string]$Commission
    [string]$Totmembers	
    [string]$Description
    [string]$YEARTERM
    [string]$MBERCOMMT
    [string]$CITYSTAFF
}

$commissionsArr = [System.Collections.Generic.List[System.Object]]::new();

function Connect-CoaPnpSite {
    Param
    (
        [parameter(Mandatory=$true)]
        $Url
    )
    $creds = Get-Credential
    Connect-PnPOnline -Url $url -Credentials $creds
    Clear-Variable Url
    Clear-Variable creds
}

function Import-CoaCsv {
    Param
    (
        [parameter(Mandatory=$true)]
        $FilePath
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
            "Title" = $_.Commission;
            "commiTotalMembers"
        }
    }
}
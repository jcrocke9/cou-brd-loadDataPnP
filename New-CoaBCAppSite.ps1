
$siteTitle = "Boards and Commissions App"
$siteUrl = "https://qa01alexandriava.sharepoint.com/sites/bcapp1"
$siteOwner = "joseph.crockett@qa01alexandriava.net"
$siteOwnerAlt = "bpos.migration@qa01alexandriava.onmicrosoft.com"
$siteTemplate = "STS#0"
$siteTimeZone = 10
$siteCred = Get-Credential
New-PnPTenantSite -Title $siteTitle -Url $siteUrl -Owner $siteOwner -Template $siteTemplate -TimeZone $siteTimeZone
Connect-PnPOnline -Url $siteUrl -Credentials $siteCred
Add-PnPSiteCollectionAdmin -Owners $siteOwnerAlt
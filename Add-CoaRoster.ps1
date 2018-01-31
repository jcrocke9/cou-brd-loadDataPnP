$commissionsList = "Commissions"
$siteUrl = "https://qa01alexandriava.sharepoint.com/sites/bcapp1"
function Add-CoaCommiRosterUrl {
    Add-PnPFieldFromXml -FieldXml '<Field ID="b0966896-ed7b-43a4-8bb3-95b163419d3a" Name="commiRosterUrl" DisplayName="Roster" Type="URL" Group="Commissions"></Field>'
    Add-PnPFieldToContentType -Field "commiRosterUrl" -ContentType Commission
    Add-PnPView -List "Commissions" -Fields "commiRosterUrl" -Title "Roster" -RowLimit 300 -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'
}

function Set-CoaItemFieldCommi {
    Get-PnPListItem -List $commissionsList -Fields "Title" | ForEach-Object {
        $itemTitle = $_["Title"]
        $itemId = $_.Id;
        Set-PnPListItem -List $commissionsList -Identity $itemId -Values @{"commiRosterUrl" = "$siteUrl/SitePages/Roster.aspx?commi=$itemTitle, $itemTitle"}
        Clear-Variable itemId;
        Clear-Variable itemTitle;   
    }
}


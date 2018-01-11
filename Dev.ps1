function Add-CoaCommiRosterUrl {
    Add-PnPFieldFromXml -FieldXml '<Field ID="b0966896-ed7b-43a4-8bb3-95b163419d3a" Name="commiRosterUrl" DisplayName="Roster" Type="URL" Group="Commissions"></Field>'
    Add-PnPFieldToContentType -Field "commiRosterUrl" -ContentType Commission
    Add-PnPView -List "Commissions" -Fields "commiRosterUrl" -Title "Roster" -RowLimit 300 -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'
}

function Set-CoaItemFieldCommi {
    Get-PnPListItem -List "Commissions" -Fields "Title" | ForEach-Object {
        $itemTitle = $_["Title"]
        $itemId = $_.Id;
        Set-PnPListItem -List "Commissions" -Identity $itemId -Values @{"commiRosterUrl" = "https://qa01alexandriava.sharepoint.com/sites/boardsqa/SitePages/Roster.aspx?commi=$itemTitle, $itemTitle"}
        Clear-Variable itemId;
        Clear-Variable itemTitle;   
    }
}

Add-PnPFieldFromXml -List "Appointee" -FieldXml '<Field ID="6b7f2d60-684b-4862-8eec-dd5b3440a422" Name="boardsTerm" DisplayName="Years Served" Type="Calculated" Formula="=IF(OR(ISBLANK([Original Date]),ISBLANK([App End Date])),[Today],DATEDIF([Original Date],[App End Date],"Y"))"></Field>'
Add-PnPView -List "Appointee" -Title "YearsServed" -Fields "boardsCommi", "Title", "FirstName", "boardsOriginalDate", "boardsTerm", "boardsEndDate" -RowLimit 5000 -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where><OrderBy><FieldRef Name="boardsTerm" Ascending="FALSE"/><FieldRef Name="boardsCommi" Ascending="TRUE"/><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'
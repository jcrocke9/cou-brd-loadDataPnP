Import-Module SharePointPnPPowerShellOnline -NoClobber
$siteUrl = "https://qa01alexandriava.sharepoint.com/sites/bcapp1"
$appointeeList = "Appointees"
$appointmentList = "Appointments"
$commissionsList = "Commissions"
$rolesList = "Roles"
# Site pages view for homepage
# Add-PnPView -List "Site Pages" -Title "Views" -RowLimit 30 -Fields "LinkFilenameNoMenu" -Query '<Where><And><Leq><FieldRef Name="SortOrder" /><Value Type="Number">12</Value></Leq><IsNotNull><FieldRef Name="SortOrder" /></IsNotNull></And></Where><OrderBy><FieldRef Name="SortOrder" Ascending="TRUE"/></OrderBy>'
# Add-PnPView -List "Site Pages" -Title "Reports" -RowLimit 30 -Fields "LinkFilenameNoMenu" -Query '<Where><And><Geq><FieldRef Name="SortOrder" /><Value Type="Number">13</Value></Geq><IsNotNull><FieldRef Name="SortOrder" /></IsNotNull></And></Where><OrderBy><FieldRef Name="SortOrder" Ascending="TRUE"/></OrderBy>'

# 1 Appointments Expiring in a Given Period
Add-PnPView -List $appointmentList -Title "ExpiringApp" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmEndDate" -Query '<Where><IsNotNull><FieldRef Name="atmEndDate"/></IsNotNull></Where><OrderBy><FieldRef Name="atmEndDate" Ascending="TRUE"/></OrderBy>'
Add-PnPView -List $appointmentList -Title "ExpiringNoDate" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmEndDate" -Query '<Where><IsNull><FieldRef Name="atmEndDate"/></IsNull></Where><OrderBy><FieldRef Name="atmEndDate" Ascending="TRUE"/></OrderBy>'

# 2 Names of Members who belong to the same board
# Add-PnPView -List $appointeeList -Title "BoardApp" -RowLimit 5000 -Fields "atmAppointee", "Title", "WorkAddress", "WorkCity", "WorkState", "WorkZip"

# 3 Appointees Names and Commissions
Add-PnPView -List $appointmentList -Title "Names" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><Neq><FieldRef Name="atmCommi" LookupId="TRUE" /><Value Type="Lookup"></Value></Neq></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 5 List of Chairpersons
Add-PnPView -List $appointmentList -Title "Chairpersons" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><Eq><FieldRef Name="atmChairman"/><Value Type="Boolean">1</Value></Eq></Where><OrderBy><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# 6 List of Appointees Who Have Not Taken Oath
Add-PnPView -List $appointmentList -Title "NoOath" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><Eq><FieldRef Name="atmOath"/><Value Type="Boolean">0</Value></Eq></Where><OrderBy><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# 7

# 8 List of City Staff
Add-PnPView -List $commissionsList -Title "CityStaff" -RowLimit 500 -Fields "Title", "commiCityStaff1" -Query '<Where><IsNotNull><FieldRef Name="commiCityStaff1" /></IsNotNull></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 9 List of Appointee EMail
Add-PnPView -List $appointeeList -Title "EMail" -RowLimit 5000 -Fields "FullName", "EMail" -Query '<Where><IsNotNull><FieldRef Name="EMail"/></IsNotNull></Where><OrderBy><FieldRef Name="FullName" Ascending="TRUE"/></OrderBy>'

# 10 List of Vacancies
# Add-PnPView -List $appointmentList -Title "Vacancies" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmAppointee" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Contains><FieldRef Name="Title"/><Value Type="Text">VACAN</Value></Contains></And></And></Where><OrderBy><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# 11 List of Appointee Deleted
# Add-PnPView -List $appointmentList -Title "Deleted" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmArchive", "boardsDeletedDate", "boardsDeletedBy", "boardsDelete" -Query '<Where><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">1</Value></Eq></Where>'

# 12 Doesn't work - Names and Boards of All Archived
# Add-PnPView -List $appointmentList -Title "Archived" -RowLimit 5000 -Fields "Title","atmAppointee","atmCommi","atmArchive" -Query '<Where><And><Eq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Eq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where>'

# 16 Committee's Public Roster
Add-PnPView -List $appointmentList -Title "PublicRoster" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmOriginalDate", "atmStartDate", "atmDateTaken", "atmEndDate" -Query '<OrderBy><FieldRef Name="atmAppointee" Ascending="TRUE"/></OrderBy>'

# 17 Attempt #1 Members on Several Boards
# Add-PnPView -List $appointmentList -Title "SeveralBoards" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/><FieldRef Name="atmAppointee" Ascending="TRUE"/><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# Roles
Add-PnPView -List $rolesList -Title "Roster" -Fields "Title" -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# =IF(OR(ISBLANK([Original Appointment Date]),ISBLANK([Appointment End Date])),"",DATEDIF([Original Appointment Date],[Appointment End Date],"Y"))
Add-PnPView -List $appointmentList -Title "YearsServed" -Fields "atmCommi", "Title", "atmAppointee", "atmOriginalDate", "atmTerm", "atmEndDate" -RowLimit 5000 -Query '<OrderBy><FieldRef Name="atmTerm" Ascending="FALSE"/><FieldRef Name="atmCommi" Ascending="TRUE"/><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'


Remove-PnPNavigationNode -Title Notebook -Location QuickLaunch -Force
Remove-PnPNavigationNode -Title Documents -Location QuickLaunch -Force
Remove-PnPNavigationNode -Title Pages -Location QuickLaunch -Force
Remove-PnPNavigationNode -Title Recent -Location QuickLaunch -Force
Add-PnPNavigationNode -Title "Appointments" -Url "$siteUrl/Lists/$appointmentList" -Location "QuickLaunch"
Add-PnPNavigationNode -Title "Appointees" -Url "$siteUrl/Lists/$appointeeList" -Location "QuickLaunch"
Add-PnPNavigationNode -Title "Commissions" -Url "$siteUrl/Lists/$commissionsList" -Location "QuickLaunch"
Add-PnPNavigationNode -Title "Roles" -Url "$siteUrl/Lists/$rolesList" -Location "QuickLaunch"

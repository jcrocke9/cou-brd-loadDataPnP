Import-Module SharePointPnPPowerShellOnline -NoClobber
$appointeeList = "Appointees"
$appointmentList = "Appointments"
$rolesList = "Roles"
$commissionsList = "Commissions"
# Site pages view for homepage
Add-PnPView -List "Site Pages" -Title "Views" -RowLimit 30 -Fields "LinkFilenameNoMenu" -Query '<Where><And><Leq><FieldRef Name="SortOrder" /><Value Type="Number">12</Value></Leq><IsNotNull><FieldRef Name="SortOrder" /></IsNotNull></And></Where><OrderBy><FieldRef Name="SortOrder" Ascending="TRUE"/></OrderBy>'
Add-PnPView -List "Site Pages" -Title "Reports" -RowLimit 30 -Fields "LinkFilenameNoMenu" -Query '<Where><And><Geq><FieldRef Name="SortOrder" /><Value Type="Number">13</Value></Geq><IsNotNull><FieldRef Name="SortOrder" /></IsNotNull></And></Where><OrderBy><FieldRef Name="SortOrder" Ascending="TRUE"/></OrderBy>'

# 1 Appointments Expiring in a Given Period
Add-PnPView -List $appointmentList -Title "ExpiringApp" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmEndDate" -Query '<OrderBy><FieldRef Name="atmEndDate" Ascending="TRUE"/></OrderBy>'

# 2 Names of Members who belong to the same board
Add-PnPView -List $appointmentList -Title "BoardApp" -RowLimit 5000 -Fields "atmAppointee", "Title", "WorkAddress", "WorkCity", "WorkState", "WorkZip"

# 3 Appointees Names and Commissions
Add-PnPView -List $appointmentList -Title "Names" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Neq><FieldRef Name="atmCommi" LookupId="TRUE" /><Value Type="Lookup"></Value></Neq></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 5 List of Chairpersons
Add-PnPView -List $appointmentList -Title "Chairpersons" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Eq><FieldRef Name="boardsChairman"/><Value Type="Boolean">1</Value></Eq></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 6 List of Appointees Who Have Not Taken Oath
Add-PnPView -List $appointmentList -Title "NoOath" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmCommi" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Eq><FieldRef Name="boardsOath"/><Value Type="Boolean">0</Value></Eq></And></And></Where><OrderBy><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# 7

# 8 List of City Staff
Add-PnPView -List "Commissions" -Title "CityStaff" -RowLimit 500 -Fields "Title", "commiCityStaff1" -Query '<Where><IsNotNull><FieldRef Name="commiCityStaff1" /></IsNotNull></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 9 List of Appointee Email
Add-PnPView -List $appointmentList -Title "Email" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "Email" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><IsNotNull><FieldRef Name="Email"/></IsNotNull></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 10 List of Vacancies
Add-PnPView -List $appointmentList -Title "Vacancies" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmAppointee" -Query '<Where><And><Neq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Contains><FieldRef Name="Title"/><Value Type="Text">VACAN</Value></Contains></And></And></Where><OrderBy><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

# 11 List of Appointee Deleted
# Add-PnPView -List $appointmentList -Title "Deleted" -RowLimit 5000 -Fields "Title", "atmAppointee", "atmCommi", "atmArchive", "boardsDeletedDate", "boardsDeletedBy", "boardsDelete" -Query '<Where><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">1</Value></Eq></Where>'

# 12 Doesn't work - Names and Boards of All Archived
# Add-PnPView -List $appointmentList -Title "Archived" -RowLimit 5000 -Fields "Title","atmAppointee","atmCommi","atmArchive" -Query '<Where><And><Eq><FieldRef Name="atmArchive" /><Value Type="Boolean">1</Value></Eq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where>'

# 16 Committee's Public Roster
Add-PnPView -List $appointmentList -Title "PublicRoster" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmAppointee", "boardsOriginalDate", "boardsStartDate", "boardsDateTaken", "atmEndDate" -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 17 Attempt #1 Members on Several Boards
Add-PnPView -List $appointmentList -Title "SeveralBoards" -RowLimit 5000 -Fields "atmAppointee", "Title", "atmAppointee", "atmCommi" -Query '<OrderBy><FieldRef Name="Title" Ascending="TRUE"/><FieldRef Name="atmAppointee" Ascending="TRUE"/><FieldRef Name="atmCommi" Ascending="TRUE"/></OrderBy>'

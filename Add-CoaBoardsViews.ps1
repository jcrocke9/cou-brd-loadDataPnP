Import-Module SharePointPnPPowerShellOnline -NoClobber

# List of Appointee Deleted
Add-PnPView -List "Appointee" -Title "Deleted" -RowLimit 5000 -Fields "Title", "FirstName", "boardsCommi", "boardsArchive", "boardsDeletedDate", "boardsDeletedBy", "boardsDelete" -Query '<Where><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">1</Value></Eq></Where>'

# Doesn't work - Names and Boards of All Archived
# Add-PnPView -List "Appointee" -Title "Archived" -RowLimit 5000 -Fields "Title","FirstName","boardsCommi","boardsArchive" -Query '<Where><And><Eq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Eq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where>'

# 1 Appointments Expiring in a Given Period
Add-PnPView -List "Appointee" -Title "ExpiringApp" -RowLimit 5000 -Fields "Title", "FirstName", "boardsCommi", "boardsArchive", "boardsEndDate", "boardsMemberType" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where><OrderBy><FieldRef Name="boardsEndDate" Ascending="TRUE"/></OrderBy>'

# 2 Names of Members who belong to the same board
Add-PnPView -List "Appointee" -Title "BoardApp" -RowLimit 5000 -Fields "FirstName", "Title", "boardsMemberType", "WorkAddress", "WorkCity", "WorkState", "WorkZip" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq></And></Where>'

# 3 Appointees Names and Commissions
Add-PnPView -List "Appointee" -Title "Names" -RowLimit 5000 -Fields "FirstName", "Title", "boardsCommi" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Neq><FieldRef Name="boardsCommi" LookupId="TRUE" /><Value Type="Lookup"></Value></Neq></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 5 List of Chairpersons
Add-PnPView -List "Appointee" -Title "Chairpersons" -RowLimit 5000 -Fields "FirstName", "Title", "boardsCommi" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Eq><FieldRef Name="boardsChairman"/><Value Type="Boolean">1</Value></Eq></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 6 List of Appointees Who Have Not Taken Oath
Add-PnPView -List "Appointee" -Title "NoOath" -RowLimit 5000 -Fields "FirstName", "Title", "boardsCommi" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Eq><FieldRef Name="boardsOath"/><Value Type="Boolean">0</Value></Eq></And></And></Where><OrderBy><FieldRef Name="boardsCommi" Ascending="TRUE"/></OrderBy>'

# 7

# 8 List of City Staff
Add-PnPView -List "Commissions" -Title "CityStaff" -RowLimit 500 -Fields "Title", "commiCityStaff1" -Query '<Where><IsNotNull><FieldRef Name="commiCityStaff1" /></IsNotNull></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 9 List of Appointee Email
Add-PnPView -List "Appointee" -Title "Email" -RowLimit 5000 -Fields "Title", "FirstName", "boardsCommi", "Email" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><IsNotNull><FieldRef Name="Email"/></IsNotNull></And></And></Where><OrderBy><FieldRef Name="Title" Ascending="TRUE"/></OrderBy>'

# 10 List of Vacancies
Add-PnPView -List "Appointee" -Title "Vacancies" -RowLimit 5000 -Fields "Title", "FirstName", "boardsCommi", "boardsMemberType" -Query '<Where><And><Neq><FieldRef Name="boardsArchive" /><Value Type="Boolean">1</Value></Neq><And><Eq><FieldRef Name="boardsDelete" /><Value Type="Boolean">0</Value></Eq><Contains><FieldRef Name="Title"/><Value Type="Text">VACAN</Value></Contains></And></And></Where><OrderBy><FieldRef Name="boardsCommi" Ascending="TRUE"/></OrderBy>'

Import-Module SharePointPnPPowerShellOnline -NoClobber
function Add-CoaBCAppLists {
    New-PnPList -Title Commissions -Template GenericList
    New-PnPList -Title Roles -Template GenericList
    New-PnPList -Title Appointments -Template GenericList
    New-PnPList -Title Appointees -Template GenericList
}
function Add-CoaSiteColumn {
    $columnXml = @(
        '<Field ID="16fb43b0-f918-4650-a7d0-be3da1527963" Name="commiTotalMembers" DisplayName="Total Members" Type="Number" Group="Commissions" Decimal="0"></Field>',
        '<Field ID="d7c291a4-0d6b-45cb-8956-514cc3f1b459" Name="commiDesc" DisplayName="Description of Commission" Type="Note" Group="Commissions"></Field>',
        '<Field ID="42f0ff7c-d509-4592-9730-10aa6b1e07fe" Name="commiTerm" DisplayName="Term" Type="Text" Group="Commissions"></Field>',
        '<Field ID="e268e6c8-a574-43f2-9a84-c5c4d7c40a77" Name="commiMberCommt" DisplayName="Member Composition" Type="Note" Group="Commissions"></Field>',
        '<Field ID="4f88b400-5dba-478d-acea-c58219932963" Name="commiCityStaff1" DisplayName="City Staff Contact" Type="Text" Group="Commissions"></Field>',
        '<Field ID="fe402d8e-dec4-4796-b6d3-3ee3b80c88f0" Name="roleVote" DisplayName="Vote" Type="Boolean" Group="Role"><Default>No</Default></Field>',
        '<Field ID="45a9c655-bc51-454e-b7e5-0108717a2e67" Name="roleType" DisplayName="Role Type" Type="Choice" Group="Role" BaseType="Text" Format="Dropdown"><CHOICES><CHOICE>Citizen</CHOICE><CHOICE>Council</CHOICE><CHOICE>Representative</CHOICE><CHOICE>Staff</CHOICE><CHOICE>Alternate</CHOICE><CHOICE>Unspecified</CHOICE></CHOICES></Field>',
        '<Field ID="54598e78-b060-42a4-a4c7-3f7ed42ea339" Name="atmMemberType" DisplayName="Member Role" Type="Text" Group="Appointment"></Field>',
        '<Field ID="a39303ee-d60f-4ee4-aee1-5027c8a06f10" Name="atmOath" DisplayName="Oath" Type="Boolean" Group="Appointment"><Default>No</Default></Field>',
        '<Field ID="837b789a-960e-4bd4-8ad2-74152cb5778b" Name="atmChairman" DisplayName="Chairman" Type="Boolean" Group="Appointment"><Default>No</Default></Field>',
        '<Field ID="5fd59375-1aa9-433e-8678-59be2c643a61" Name="atmStartDate" DisplayName="Appointment Start Date" Type="DateTime" Format="DateOnly" Group="Appointment"></Field>',
        '<Field ID="a9cbe2b7-1112-4ea1-89d1-aaee5998e34d" Name="atmEndDate" DisplayName="Appointment End Date" Type="DateTime" Format="DateOnly" Group="Appointment"></Field>',
        '<Field ID="3e100216-a062-428c-b47c-59439e47aef4" Name="atmOriginalDate" DisplayName="Original Appointment Date" Type="DateTime" Format="DateOnly" Group="Appointment"></Field>',
        '<Field ID="4caacdb5-1eff-4b43-905e-8ead2e485047" Name="atmDateTaken" DisplayName="Date Oath Taken" Type="DateTime" Format="DateOnly" Group="Appointment"></Field>',
        '<Field ID="e2d7556d-b67d-42fd-b883-bc8ef1fef0c3" Name="atmArchive" DisplayName="Archive" Type="Boolean" Group="Appointment"><Default>No</Default></Field>',
        '<Field ID="264346f4-bda5-4c8e-99e0-6f68cb702670" Name="atmDelete" DisplayName="Delete" Type="Boolean" Group="Appointment"><Default>No</Default></Field>',
        '<Field ID="9a69b990-d2a4-4f59-9286-e80363897b97" Name="atmDeletedDate" DisplayName="Deleted When" Type="DateTime" Format="DateOnly" Group="Appointment"></Field>',
        '<Field ID="9d7a2e52-9dd0-4bd8-a325-853cc911334b" Name="atmDeletedBy" DisplayName="Deleted By" Type="Text" Group="Appointment"></Field>',
        '<Field ID="df3958d8-a3bb-4f51-b252-28f73c59e90e" Name="atmDesc" DisplayName="Comments" Type="Note" Group="Appointment"></Field>'
    );
    $columnXml | ForEach-Object {
        Add-PnPFieldFromXml -FieldXml $_
    }
}
function Add-CoaSiteContentTypes {
    Add-PnPContentType -Name "Commission" -Group "Boards"
    Add-PnPContentType -Name "Role" -Group "Boards"
    Add-PnPContentType -Name "Appointee" -Group "Boards"
    Add-PnPContentType -Name "Appointment" -Group "Boards"
}
function Add-CoaColumnToCtCommission {
    $columnNames = @('commiTotalMembers', 'commiDesc', 'commiTerm', 'commiMberCommt', 'commiCityStaff1');
    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Commission
    }
}
function Add-CoaColumnToCtRole {
    $columnNames = @('roleVote', 'roleType');
    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Role
    }
}
function Add-CoaColumnToCtAppointee {
    $columnNames = @('FirstName', 'WorkAddress', 'WorkCity', 'WorkState', 'WorkZip', 'EMail', 'HomePhone', 'WorkPhone', 'WorkFax', 'Company');
    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Appointee
    }
}
function Add-CoaColumnToCtAppointment {
    $columnNames = @('atmMemberType', 'atmOath', 'atmChairman', 'atmStartDate', 'atmEndDate', 'atmOriginalDate', 'atmDateTaken', 'atmArchive', 'atmDelete', 'atmDeletedDate', 'atmDeletedBy', 'atmDesc');
    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Appointment
    }
}
function Add-CoaPnPContentTypeToList {
    Add-PnPContentTypeToList -List "Commissions" -ContentType "Commission" -DefaultContentType
    Add-PnPContentTypeToList -List "Roles" -ContentType "Role" -DefaultContentType
    Add-PnPContentTypeToList -List "Appointees" -ContentType "Appointee" -DefaultContentType
    Add-PnPContentTypeToList -List "Appointments" -ContentType "Appointment" -DefaultContentType
}
function Add-CoaSiteColumnLookups {
    $columnXml = @(
        '<Field ID="24e1e1cd-1a6f-4299-a2c6-10f20b05add1" Name="roleCommi" DisplayName="Commission" Group="Role" Type="Lookup" List="Lists/Commissions" ShowField="Title"></Field>',
        '<Field ID="e927d8ec-2fdd-4b7d-a623-53c7b7a9aa1b" Name="atmCommi" DisplayName="Commission" Group="Appointment" Type="Lookup" List="Lists/Commissions" ShowField="Title"></Field>',
        '<Field ID="4ad4298b-076f-4581-b595-90e0c11ffa78" Name="atmRole" DisplayName="Role" Group="Appointment" Type="Lookup" List="Lists/Roles" ShowField="Title"></Field>',
        '<Field ID="7ec3175e-93eb-4cb7-8a50-f8671729e53f" Name="atmAppointee" DisplayName="Appointee" Group="Appointment" Type="Lookup" List="Lists/Appointee" ShowField="Title"></Field>'
    );
    $columnXml | ForEach-Object {
        Add-PnPFieldFromXml -FieldXml $_
        $CommissionsList = Get-PnPList -Identity "Commissions"
        Add-PnPField -DisplayName "Commission" -InternalName "roleCommi" -Type "Lookup" -List $CommissionsList -Group "Role"
    }
}
function Add-CoaColumnToCtRole2nd {
    Add-PnPFieldToContentType -Field 'roleCommi' -ContentType Role
}
function Add-CoaColumnToCtAppointment2nd {
    $columnNames = @('atmCommi', 'atmRole', 'atmAppointee');
    $columnNames | ForEach-Object {
        $_
        Add-PnPFieldToContentType -Field $_ -ContentType Appointment
    }
}
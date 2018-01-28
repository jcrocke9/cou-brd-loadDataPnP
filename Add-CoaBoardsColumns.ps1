Import-Module SharePointPnPPowerShellOnline -NoClobber

function Add-CoaSiteColumn {
    $columnXml = @(
        '<Field ID="e2d7556d-b67d-42fd-b883-bc8ef1fef0c3" Name="boardsArchive" DisplayName="Archive" Type="Boolean" Group="Boards"><Default>No</Default></Field>',
        '<Field ID="264346f4-bda5-4c8e-99e0-6f68cb702670" Name="boardsDelete" DisplayName="Delete" Type="Boolean" Group="Boards"><Default>No</Default></Field>',
        '<Field ID="9a69b990-d2a4-4f59-9286-e80363897b97" Name="boardsDeletedDate" DisplayName="Deleted When" Type="DateTime" Format="DateOnly" Group="Boards"></Field>',
        '<Field ID="9d7a2e52-9dd0-4bd8-a325-853cc911334b" Name="boardsDeletedBy" DisplayName="Deleted By" Type="Text" Group="Boards"></Field>',
        '<Field ID="df3958d8-a3bb-4f51-b252-28f73c59e90e" Name="boardsDesc" DisplayName="Comments" Type="Note" Group="Boards"></Field>'
    );

    $columnXml | ForEach-Object {
        Add-PnPFieldFromXml -FieldXml $_
    }
}

function Add-CoaPnpColumn {
    Add-PnPContentType -Name "Appointee" -Group "Boards" -ContentTypeId "0x010600E5CBF6B903699749874CFA22ED22F53E"
    Add-PnPContentType -Name "Commission" -Group "Commissions" -ContentTypeId "0x01006478A9A7A361B441BEA035F7767CA597"
}

function Add-CoaColumnToCt {
    $columnNames = @('boardsDelete','boardsDeletedDate','boardsDeletedBy','boardsDesc');

    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Appointee
    }
}

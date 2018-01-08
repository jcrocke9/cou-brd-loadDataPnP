Get-PnPListItem -List Appointee | foreach {
    Remove-PnPListItem -List Appointee -Identity $_.Id -Force
}
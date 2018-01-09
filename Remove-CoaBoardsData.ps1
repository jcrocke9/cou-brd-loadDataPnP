Import-Module SharePointPnPPowerShellOnline -NoClobber

Get-PnPListItem -List Appointee | ForEach-Object {
    Remove-PnPListItem -List Appointee -Identity $_.Id -Force
}
Connect-SPOService -Url https://tenant-admin.sharepoint.com/
Get-SPOSite -Limit All | Export-CSV -LiteralPath C:\Temp\SitesInventoryaspirent.csv -NoTypeInformation

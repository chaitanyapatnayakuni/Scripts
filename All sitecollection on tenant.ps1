Connect-SPOService -Url https://nttdatagroup-admin.sharepoint.com/
Get-SPOSite -Limit All | Export-CSV -LiteralPath C:\Temp\SitesInventoryaspirent.csv -NoTypeInformation

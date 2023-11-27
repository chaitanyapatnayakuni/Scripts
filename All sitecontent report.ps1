#Connect-SpoService -URL https://nttdatagroup-admin.sharepoint.com
$csv = Import-csv -Path "C:\temp\OneDrive\Chainalytics\testing.csv"#contain site column called "SiteURL"
$OutReport= "C:\temp\OneDrive\Chainalytics\targetreport2607MST.csv"
$username="spmigration8.svc@nttdata.com"
$password  ="gI=ZN%7hD8kq9*5@@&8%8#9)"
$logpath = "C:\temp\FolderCreation_Log_{0}.txt" -f [DateTime]::Now.ToString("yyyy-MM-dd_hh-mm-ss")
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
$Report = [System.Collections.Generic.List[Object]]::new()
 foreach($site in $csv){
   Set-SPOUser -Site $site.SiteURL -LoginName $username -IsSiteCollectionAdmin $true
   Connect-PnPOnline -Url $site.SiteURL -Credentials $cred
   #$list=Get-PnPList -Identity $site.List
   $ExcludedLists  = @("Reusable Content","Content and Structure Reports","Form Templates","Images","Pages","Workflow History","Workflow Tasks", "Preservation Hold Library")
   $Lists = Get-PnPList | Where {$_.Hidden -eq $False -and $ExcludedLists -notcontains $_.Title}
   $Site = Get-SPOSite -identity $site.SiteURL | Select-Object Owner, List, Title, URL, ListURL, StorageQuota, StorageUsageCurrent,LastContentModifiedDate, LockState
   #Set-SPOUser -Site $site.URL -LoginName $username -IsSiteCollectionAdmin $false
    
   foreach ($List in $Lists){
    #
    #Write-host -f Yellow "Getting List Item count from site:" $site.SiteURL
    $ReportLine   =[PSCustomObject] @{
        Title       = $Site.Title
       Email       = $Site.Owner
        URL         = $Site.URL
        List       = $List.Title
        ListURL    = $List.RootFolder.ServerRelativeUrl
        ItemCount   = $List.ItemCount
        QuotaGB     = [Math]::Round($Site.StorageQuota/1024,2) 
        UsedGB      = [Math]::Round($Site.StorageUsageCurrent/1024,4)
        PercentUsed = [Math]::Round(($Site.StorageUsageCurrent/$Site.StorageQuota * 100),4)
        LastContentModifiedDate = $site.LastContentModifiedDate
        LockState = $site.LockState
        
}
   


 $ReportLine | Export-CSV -NoTypeInformation -Path $OutReport -Force -Append
 }
 }

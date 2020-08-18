## PowerShell User Data Backup & Restore Scripts

When I came into my current role in Desktop Support, we were using BATCH scripts to perform these tasks. However, I wanted to move them to PowerShell. 

#### My goals for creating this were:

1. Keep the process simple
2. Provide seamless transition for my team
3. Backup and Restore the same information as before

#### What does the script backup and restore:

1. All user data (Desktop, Documents, Downloads, Favorites, Pictures)
2. Browser data from Google Chrome and Firefox
3. Network printer information and Mapped Network drives

Code snippet:

```PowerShell
#region DeclaringDataBackupSources
$folder = "Desktop",
  "Downloads",
  "Favorites",
  "Documents",
  "Pictures",
  "AppData\Local\Google\Chrome\User Data",
  "AppData\Local\Mozilla\Firefox\Profiles",
  "AppData\Roaming\Mozilla\Firefox"
#endregion DeclaringDataBackupSources
```

#### What's been added

I added a little piece to the backup script to clear all browser cache to allow the backup time to decrease.

Here is a snippet of that code:

```Power
##region CacheFolderDeletion Variables (Currently supports Chrome and Firefox)
$delete = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\",
  "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache\",
  "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Service Worker\ScriptCache",
  "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Cache\",
  "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Code Cache\",
  "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Service Worker\ScriptCache",
  "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default\cache",
  "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*.default\cache2"
##endregion CacheFolderDeletion Variables

##region DeleteFiles
Write-Host -ForegroundColor Cyan "Begin Browser Cleanup"
Get-ChildItem -Path $delete | Remove-Item -Verbose -Recurse
##endregion
```

The script has been tested on Windows 7 and Windows 10 and is 100% working.

#### Variables to setup

For the Backup script:

```PowerShell
$destination
```

For the Restore script:

```PowerShell
$source
```



**Please feel free to use and modify the script to suit your needs.**

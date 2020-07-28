##
######## Powershell Script for Backing up User Data ########
##
######## Also Deletes Browser Cache ########
##
######## v5.0 7/20/20 ########
##
######## By Aaron Zercher ########
##
######## Script will backup all data in Desktop, Documents, Downloads, Favorites, Pictures, Chrome, and Mozilla Data ########
##
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

##region Switch to Backup
Start-Sleep -Seconds 30
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor Yellow "Standby Loading Backup Script..."
Start-Sleep -Seconds 10
Clear-Host
##end region Switch to Backup

#region GetVariables
[String]$Technician = Read-Host -Prompt "What Technician is auditing this computer (First name only)"
[String]$NetworkPassword = Read-Host -Prompt "Please enter the Users network password" ##NEEDED
#endregion GetVariables

#region DeclaringBackuplocation
$destination = "(Your Destination here)"
#endregion DeclaringBackuplocation

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

###### Backup Data section ########
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor green "Backing up data from local machine for $env:USERNAME"

#region Folder creation
New-Item -Type Directory -Path $destination -Name "Audit Information" -Force | Out-Null
New-Item -Type Directory -Path $destination -Name "RegistryInformation" -Force | Out-Null
New-Item -Type Directory -Path $destination -Name "RegistryInformation\Temp" -Force | Out-Null
#endregion Folder creation

#region DataBackup
ForEach ($f in $folder) {
    $currentLocalFolder = Join-Path -Path $env:USERPROFILE -ChildPath $f
    $currentRemoteFolder = Join-Path -Path $destination -ChildPath $f
    $currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $currentLocalFolder -Recurse -Force | Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
    $currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
    Write-Host -ForegroundColor cyan "  $f... ($currentFolderSizeRounded MB)"
    Copy-Item -ErrorAction silentlyContinue -recurse $currentLocalFolder $currentRemoteFolder
}
#endregion DataBackup

#Yes this is unsecure but needs to be done.
##region PasswordFileCreation
Out-file -filepath "$destination\Audit Information\NewBuild.txt" -inputobject $NetworkPassword
##endregion PasswordFileCreation

##region Registry Backup
Write-Host -ForegroundColor green "Backing up registry data from local machine for $env:USERNAME"
  $keys = "HKCU\Network", "HKCU\Printers", "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Devices", "HKCU\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts", "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows"

  $tempFolder = "$destination\RegistryInformation\temp"
  $outputFile = "$destination\RegistryInformation\RegBackup.reg"

$keys | ForEach-Object {
  $i++
  & reg export $_ "$tempFolder\$i.reg"
}

"Windows Registry Editor Version 5.00" | Set-Content $outputFile
Get-Content "$tempFolder\*.reg" | Where-Object {
  $_ -ne "Windows Registry Editor Version 5.00"
} | Add-Content $outputFile
##endregion Registry Backup
Write-Host ""
Write-Host -ForegroundColor green "Registry Backup Complete"
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor green "Backup complete! You my shutdown the computer"
Start-Sleep -Seconds 15

##region shutdownPC
Stop-Computer -Confirm
##endregion shutdownPC

##Script completes

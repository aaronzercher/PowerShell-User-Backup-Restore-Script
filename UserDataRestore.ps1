##
######## Powershell Script for Restoring User Data ########
##
######## v4.0 7/20/20 ########
##
######## By Aaron Zercher ########
##
######## Script will restore all data in Desktop, Documents, Downloads, Favorites, Pictures, Chrome, and Mozilla Data ########
##
##Declares the values and prompts for Technician information
$Technician = Read-Host -Prompt "What Technician is auditing this computer (First name only)"

##Declares the Restore location ########
$source = "(Your Source)"

##region Declaring Data to backup
$folder = "Desktop",
    "Downloads",
    "Favorites",
    "Documents",
    "Pictures"
##Folder 2 is used for Browser data
$folder2 = "AppData\Local\Google\Chrome\",
    "AppData\Local\Mozilla\Firefox\Profiles",
    "AppData\Roaming\Mozilla\Firefox"
#endregion DeclaringDataRestoreSources

###### Restore Data section ########
write-host -ForegroundColor green "Restoring data to local machine for $env:USERNAME"

foreach ($f in $folder)
{
	$currentLocalFolder = $env:USERPROFILE + "\"
	$currentRemoteFolder = $source + "\" + $f
	$currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $currentRemoteFolder -Recurse -Force | Measure-Object -ErrorAction Inquire -Property Length -Sum ).Sum / 1MB
	$currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
	write-host -ForegroundColor Magenta "  $f... ($currentFolderSizeRounded MB)"
	Copy-Item -Force -recurse $currentRemoteFolder $currentLocalFolder
}

 foreach ($f2 in $folder2)
{
    $currentLocalFolder = Join-Path $env:USERPROFILE (Split-Path $f2)
    $currentRemoteFolder = $source + "\" + $f2
	$currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $currentRemoteFolder -Recurse -Force | Measure-Object -ErrorAction Inquire -Property Length -Sum ).Sum / 1MB
	$currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
	write-host -ForegroundColor Magenta "  $f2... ($currentFolderSizeRounded MB)"
    Robocopy.exe /mir $currentRemoteFolder $currentLocalFolder
}

######## Begin Registry Restore ########
$RegistryRestore = Join-Path -Path $Source -ChildPath "RegistryInformation\RegBackup.reg"
If (Test-Path -Path $RegistryRestore) {
    Try {
        & Reg import "$RegistryRestore"
        If ($LastExitCode -NE "0") {
            Break
            # See https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/reg-import#remarks
        } # END If LastExistCode NE 0
    } # END Try Reg Import
    Catch {
        Write-Warning -Message "Critical error/failure when attempting to import registry-backup!"
    } # END Catch Reg Import
} # END If Test-Path RegistryBackup
Else {
    Write-Warning -Message "Registry Backup not found at "$($RegistryRestore)"!"
} # END Else Test-Path RegistryBackup

write-host -ForegroundColor green "Restore complete! Select Yes to Reboot the Computer"

Restart-Computer -confirm

##
######## Powershell Script for Restoring User Data ########
##
######## v1.0 11/24/18 ########
##
######## By Aaron Zercher ########
##
######## Script will restore all data in Desktop, Documents, Downloads, Favorites, Music, Pictures, Videos, Chrome, and Mozilla Data ########
##
######## Declares the values and prompts for Technician and Username information ########
$Technician = Read-Host -Prompt "What Technician is auditing this computer (First name only)"
$Username = Read-Host -Prompt "Who does this computer belong to (First initial, last name)"

######## Declares the Restore location ########
$source = "<#Desired Location here#>"

######## Declares the data to be restored ########
$folder = "Desktop",
"Downloads",
"Favorites",
"Documents",
"Music",
"Pictures",
"Videos",
"AppData\Local\Mozilla",
"AppData\Local\Google\Chrome",
"AppData\Roaming\Mozilla"

######## Calls Eviroment Variables for the local user and data location ########
$username = gc env:username
$userprofile = gc env:userprofile
$appData = gc env:localAPPDATA

###### Backup Data section ########

	write-host -ForegroundColor green "Restoring data to local machine for $username"

    foreach ($f in $folder)
	{
		$currentLocalFolder = $userprofile + "\"
		$currentRemoteFolder = $source + "\" + $f
		$currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $source -Recurse -Force | Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
		$currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
		write-host -ForegroundColor cyan "  $f... ($currentFolderSizeRounded MB)"
		Copy-Item -ErrorAction silentlyContinue -recurse $currentRemoteFolder $currentLocalFolder
	}

######## Begin Registry Backup ########
	Write-Host -ForegroundColor Green "Restoring up Network settings"
	Import-CliXML "$destination\RegistryInformation\network.reg"
	Write-Host -ForegroundColor Green "Restore of Network Settings Completed Successfully"
	Write-Host -ForegroundColor Green "Restoring up Printers"
	Import-CliXML "$destination\RegistryInformation\printers.reg"
	Write-Host -ForegroundColor Green "Restore of Printers Completed Successfully"
	Write-Host -ForegroundColor Green "Restoring up Printers1"
	Import-CliXML "$destination\RegistryInformation\printers1.reg"
	Write-Host -ForegroundColor Green "Restore of Printers 1 Completed Successfully"
	Write-Host -ForegroundColor Green "Restoring up Printers2"
	Import-CliXML "$destination\RegistryInformation\printers2.reg"
	Write-Host -ForegroundColor Green "Restore of Printers 2 Completed Successfully"
	Write-Host -ForegroundColor Green "Restoring up Printers3"
	Import-CliXML "$destination\RegistryInformation\printers3.reg"
	Write-Host -ForegroundColor Green "Restore of Printers 3 Completed Successfully"

	write-host -ForegroundColor green "Restore complete!"
	Wait
	Restart-Computer -confirm

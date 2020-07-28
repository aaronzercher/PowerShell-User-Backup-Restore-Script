# Backup-and-Restore-scripts
PowerShell Scripts to run to perform a backup and restore of User data to a Server location. Feel free to edit the script and manipulate the code to your desire.

Edited by Aaron Zercher 7/28/20.

# Additional Information
The Script is 100% working. The Script performs the following backups:
1. UserData (Documents, Desktop, Downloads, Favorites, Pictures, Music, Videos)
2. Browser Data for Mozilla FireFox and Google Chrome (I am sure you could add Opera and other browsers in here as well)
3. Registry settings:
   - Mapped Network drives
   - Printers (network and PDF)
4. The Backup script clears browser cache before beginning the backup. This helps reduce the size of the backed up data. Currently Chrome and Firefox are only cleared. More could be added if needed.   


The Prompt for Technician, Username, and password are used for my works criteria and can be omitted or changed.

# Getting Started
Begin the following order:
1. Set your variable for $source.
2. Run the script with Execution unrestricted
3. Be logged in as the user you wish to backup (this should be obvious but need to put this here)

Please comment if you have any questions or suggestions for edits. If you wish to use the code, please Fork it.

Thanks,
Aaron

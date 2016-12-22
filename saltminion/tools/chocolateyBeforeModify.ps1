# Need to keep a copy of the C:\salt\conf\minion and minion.d files in case the user is upgrading and wants to persist their existing settings.
$chocoBackup =  '$env:ProgramData\chocolatey\lib-bkp\saltconfig'
$saltConfig = 'C:\salt\conf\'
# Items to keep around, 'pki' is "identity", 'minion[_id]' is settings and ID, 'minion.d' is additional settings
#if (Test-Path $saltConfig ) { copy-item $saltConfig $chocoBackup -recurse }
# In chocolateyInstall.ps1 will need to look for a previous backup and restore files either before install or after upgrade (only IF the master & minion ID match?)
# if (Test-Path $chocoBackup) { copy-item $chocoBackup $saltConfig -recurse }
# Maybe do the backup via another package that simply assumes C:\salt\conf and performs the backup? but reverse-depends don't work here
# In chocolateyUninstall.ps1 will need to remove $chocoBackup if it exists but only if doing a real uninstall and not an upgrade

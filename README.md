ChocolateySaltMinion
====================

A chocolatey package to install a salt minion.

Supports /master=yoursaltmaster and /minion=yourminionname parameters. These arguments are passed to the package eg `--params /master=yoursaltmaster`.
- Default (no params) values are:
  - master (salt)
  - minion (hostname)
- Installs as a windows service. This runs automatically
- Uninstaller no longer requires user confirmation (upstream bug in the Salt uninstaller).

Chocolatey doesn't support dashes in a version. This may cause alternate versioning on the Chocolatey Gallery vs the exe name. 
- 2015.5.1-3 might be 2015.5.1.3
- 2015.5.0-2 might be 2015.5.0.2
- 2014.7.5-2 might be 2014.7.5.2
- etc

Maintaining (New Verisons)
==========================

Create one directory for each maintained version. You can clone the directory for the latest version and update the install scripts. Most likely you'll just need to update the installer URLs and checksums in `chocolateyInstall.ps1` for the x68 and x64 platforms. This project uses the SaltProject `.exe` installers.

Files that pre-date this structure are located under `legacy`.

Create the package and push
===========================

Read this documentation: https://chocolatey.org/docs/create-packages-quick-start#quick-start-guide
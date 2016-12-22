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

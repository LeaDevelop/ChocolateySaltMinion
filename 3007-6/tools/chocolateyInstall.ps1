$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3007.6/Salt-Minion-3007.6-Py3-AMD64-Setup.exe'
$checksum64_py3 = '5a90654253923998451379b215897b496afcb45d84b1f1d0dca465b1e896b0e8'
$url_py3        = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3007.6/Salt-Minion-3007.6-Py3-x86-Setup.exe'
$checksum_py3   = 'f9dc60223152eea2c6d2eace5dfc1f8b2b5c3072a62d7601303ef7aa2a8df4e9'

$packageArgs = @{
  packageName     = 'salt-minion'
  unzipLocation   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType        = 'EXE'

  softwareName    = 'Salt*'

  url             = $url_py3
  checksum        = $checksum_py3
  checksumType    = 'sha256'

  url64bit        = $url64_py3
  checksum64      = $checksum64_py3
  checksumType64  = 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0, 3010, 1641)
}


$packageParameters = Get-PackageParameters

if ($packageParameters['Master']) {
  $Master = $packageParameters['Master']
  $packageArgs['silentArgs'] += " /master=$Master"
}

if ($packageParameters['MinionName']) {
  $MinionName = $packageParameters['MinionName']
  $packageArgs['silentArgs'] += " /minion-name=$MinionName"
}

if ($packageParameters['MinionStart']) {
  $MinionStart = $packageParameters['MinionStart']
  $packageArgs['silentArgs'] += " /start-minion=$MinionStart"
}

if ($packageParameters['MinionStartDelayed'] -eq 'true') {
  $packageArgs['silentArgs'] += " /start-minion-delayed"
}

if ($packageParameters['DefaultConfig'] -eq 'true') {
  $packageArgs['silentArgs'] += " /default-config"
}

if ($packageParameters['CustomConfig']) {
  $CustomConfig = $packageParameters['CustomConfig']
  $packageArgs['silentArgs'] += " /custom-config=$CustomConfig"
}

Install-ChocolateyPackage @packageArgs

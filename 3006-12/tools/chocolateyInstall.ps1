﻿$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.12/Salt-Minion-3006.12-Py3-AMD64-Setup.exe'
$checksum64_py3 = '45e2a9478afbf4032c8a7e68e4e36bbc326165e3497b05e91dfc5952215e3046'
$url_py3        = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.12/Salt-Minion-3006.12-Py3-x86-Setup.exe'
$checksum_py3   = '62c713d5fa7256aa6f91b5151d228a7033c4aa0fc84bd628667fab708ed3a7c2'

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

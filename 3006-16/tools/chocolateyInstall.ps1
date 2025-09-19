$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.16/Salt-Minion-3006.16-Py3-AMD64-Setup.exe'
$checksum64_py3 = '36e9e7144b66c9b6b9c9f4460eaf0b13e82d7f493f1420dfa3a03e1c38d7e9d2'
$url_py3        = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.16/Salt-Minion-3006.16-Py3-x86-Setup.exe'
$checksum_py3   = '0cb02955492804e2e750227a79f9d035322846de4d1969e7974dccf1e1ec1d8f'

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

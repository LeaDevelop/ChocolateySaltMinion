$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/3006/Salt-Minion-3006.7-Py3-AMD64-Setup.exe'
$checksum64_py3 = '13ba9986657f063d4d521a4798a4fabf5594b2ffae3be57db4d7c025a4eca1a324e219068e33829181d734ba9957257d178a9488fbe93c8d48487966a0bab11c'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/3006/Salt-Minion-3006.7-Py3-x86-Setup.exe'
$checksum_py3   = 'd6a0dd688cd90c010656cd94b2c091d79a6e72221f28ce52e5592a34248d256c331f04a181df6040e5ec074b2c6e9aeff28608e95f0f1ab6f1bea729c4bb3f10'

$packageArgs = @{
  packageName     = 'salt-minion'
  unzipLocation   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType        = 'EXE'

  softwareName    = 'Salt*'

  url             = $url_py3
  checksum        = $checksum_py3
  checksumType    = 'sha512'

  url64bit        = $url64_py3
  checksum64      = $checksum64_py3
  checksumType64  = 'sha512'

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

$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.8/Salt-Minion-3006.8-Py3-AMD64-Setup.exe'
$checksum64_py3 = 'ee0954f0537423bd5b909db998bd656bb31f527c902f8b138d7b04cb967282a291d4f57644fb6284d145ae96cc48a5498b75eb638a9b4eed05a47acf1531c9c2'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.8/Salt-Minion-3006.8-Py3-x86-Setup.exe'
$checksum_py3   = '8c1cc885c1d58754c07d1a6cd08821ea298706e41c23bbf85fee2565fb2bf396af2f3ef04850476757b44cf3280166b71c3000ae7bc61645094280637619e77b'

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

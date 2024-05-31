$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3007.1/Salt-Minion-3007.1-Py3-AMD64-Setup.exe'
$checksum64_py3 = '504009DDB8EBBAAC8A33079611E9A845C50BEFA166F59C6D8A3EC6598BF716575CD847030367AA3399AF956561B848D98CE9F7CE3F14A8E8A3D754AA6ED565FF'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3007.1/Salt-Minion-3007.1-Py3-x86-Setup.exe'
$checksum_py3   = '98124D48D4D10FE60FDB7ABDF033BD64F617CCB9BCDB7F8349A5C1D66F9CE163A0D3AFF71D2CD5F912117096EA9CE07E56947EE7D9F6FCEDCEDCA5ACCBFDAB31'

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

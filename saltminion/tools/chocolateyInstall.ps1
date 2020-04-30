$ErrorActionPreference = 'Stop';

# Python 2
$url_py2        = 'https://repo.saltstack.com/windows/Salt-Minion-3000.2-Py2-x86-Setup.exe'
$checksum_py2   = '2BD34BF9A5163FFE77187E14F0EE5DFE'
$url64_py2      = 'https://repo.saltstack.com/windows/Salt-Minion-3000.2-Py2-AMD64-Setup.exe'
$checksum64_py2 = '74270B8CCCE73289E1673D666B0C0510'

# Python 3
$url_py3        = 'https://repo.saltstack.com/windows/Salt-Minion-3000.2-Py3-x86-Setup.exe'
$checksum_py3   = 'F073E3B750E871978AFDCF8725B2AB39'
$url64_py3      = 'https://repo.saltstack.com/windows/Salt-Minion-3000.2-Py3-AMD64-Setup.exe'
$checksum64_py3 = 'A22646DBC963C9240EAB133180969CE6'

$packageArgs = @{
  packageName     = 'salt-minion'
  unzipLocation   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType        = 'EXE'

  softwareName    = 'Salt*'

  url             = $url_py3
  checksum        = $checksum_py3
  checksumType    = 'md5'

  url64bit        = $url64_py3
  checksum64      = $checksum64_py3
  checksumType64  = 'md5'

  silentArgs    = "/S"
  validExitCodes= @(0, 3010, 1641)
}


$packageParameters = Get-PackageParameters

if ($packageParameters['Python2'] -eq 'true') {
  $packageArgs['url']         = $url_py2
  $packageArgs['checksum']    = $checksum_py2

  $packageArgs['url64bit']    = $url64_py2
  $packageArgs['checksum64']  = $checksum64_py2
}

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

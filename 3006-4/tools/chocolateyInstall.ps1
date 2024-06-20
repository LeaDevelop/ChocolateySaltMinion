$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.4/Salt-Minion-3006.4-Py3-AMD64-Setup.exe'
$checksum64_py3 = '23E56D94FA6C0E484543CE7A36C4EE1A03B222349A761C2CCFC1AA55D37E9CFDABE20B6DB01C75C767EBABCD153086EBAC37C083C76FD8FD0567DB597EF21300'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.4/Salt-Minion-3006.4-Py3-x86-Setup.exe'
$checksum_py3   = '469DC69A2A90766E6E60E7D1725C1C7881A139F789F4C6BC09B2FB432E9BB749E3FD92726CA5DC3ED2E4A7CF5F0E25BA1D827BB645EC8B6E9EC7EB6452612ADC'

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

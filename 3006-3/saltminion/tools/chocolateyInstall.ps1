$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.3/Salt-Minion-3006.3-Py3-AMD64-Setup.exe'
$checksum64_py3 = '4673C0E5C8AC411AAC0CA51745064E01382E1910E534E4162E8F50C4998C1702C869F1E440CB4690C528BA66371F577E871F988D894D4FF32FE15E1E1CC4D82F'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.3/Salt-Minion-3006.3-Py3-x86-Setup.exe'
$checksum_py3   = '13EBABB7D106A8D0EA3E624C918444F0F75F364E1484503131B9A8A4561B0329B335DFB466838BA77BF9FAAB2DE1B1071BC6058B78B85C5C7863E0A7AD2B4168'

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

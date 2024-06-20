$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.6/Salt-Minion-3006.6-Py3-AMD64-Setup.exe'
$checksum64_py3 = '1FB6A288DD00BB7C2B4AF408D9B58655892CA76EF9AB29991EF78E6DF8F5BC60411E665774C26818E382DBFB06211B560A6A5C41779BF16E04CFFC42A5468781'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.6/Salt-Minion-3006.6-Py3-x86-Setup.exe'
$checksum_py3   = '11BE55F3C8E8467A6D2D44BA0E25F335D5DAE856D94FBC4D6D50F3A2015AEA66483AC0BE59EB90D57A9500DA89E50EC0666DCB1151BBED3E28668E4546E1F3CF'

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

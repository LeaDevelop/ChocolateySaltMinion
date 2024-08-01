$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.9/Salt-Minion-3006.9-Py3-AMD64-Setup.exe'
$checksum64_py3 = '0056c64fd9fcb519d2dd30d1d0d43f3e03b3e5051fd88fbf0a987ae6225cc461df0a36207eea9ee59edc9bad2ce5e65cfdbc9ad7d78a582493af9b5f2643238a'
$url_py3        = 'https://repo.saltproject.io/salt/py3/windows/minor/3006.9/Salt-Minion-3006.9-Py3-x86-Setup.exe'
$checksum_py3   = 'f2e5f8c4f1d9c9993be643dd62e972352919de0e25d9c45efa96e7abc22fa323f61eed285939008c1972ad0a6f4b02ace6d7e4435a6d0127346d8101af4aadca'

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

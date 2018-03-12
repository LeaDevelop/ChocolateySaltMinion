$packageName = 'saltminion'

# Update these URLs and checksums when deploying a new version
$url = 'https://repo.saltstack.com/windows/Salt-Minion-2017.7.4-Py2-x86-Setup.exe'
$checksum = '9F762B7C912B410698DBFFF677BDA946'
$url64 = 'https://repo.saltstack.com/windows/Salt-Minion-2017.7.4-Py2-AMD64-Setup.exe'
$checksum64 = '16F4A9FF5639307D952D87545CDF8AE7'

# Get arguments to download the file from the URLs and checksums above
$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  silentArgs    = "/S"
  softwareName  = 'Salt*'
  checksum      = $checksum
  checksumType  = 'md5'
  checksum64    = $checksum64
  checksumType64= 'md5'
}

$arguments = @{};
# /master=myMaster /minion=myMinion
$packageParameters = $env:chocolateyPackageParameters;
$packageParameters
# Default the values
$saltMaster = ''
$minionName = ''

# Now parse the packageParameters using good old regular expression
if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+))=(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    #"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
          $arguments.Add(
              $_.Groups[$option_name].Value.Trim(),
              $_.Groups[$value_name].Value.Trim())
      }
    }
    else
    {
      throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("master")) {
        Write-Host "You specified a custom master address"
        $saltMaster = $arguments['master']
        $packageArgs['silentArgs'] += " /master=$saltMaster"
    }

    if ($arguments.ContainsKey("minion")) {
        Write-Host "You specified a custom minion ID"
        $minionName = $arguments['minion']
        $packageArgs['silentArgs'] += " /minion-name=$minionName"
    }
} else {
    Write-Debug "No Package Parameters Passed in, using defaults of /master=salt and /minion=$env:COMPUTERNAME"
}
install-ChocolateyPackage @packageArgs


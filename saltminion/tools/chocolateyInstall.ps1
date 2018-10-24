$packageName = 'saltminion'

# Update these URLs and checksums when deploying a new version
$url64 = 'https://repo.saltstack.com/windows/Salt-Minion-2018.3.3-Py3-AMD64-Setup.exe'
$checksum64 = '2C83137ADE1420BBFCC03CCD2A3EA2AC'
$url = 'https://repo.saltstack.com/windows/Salt-Minion-2018.3.3-Py3-x86-Setup.exe'
$checksum = 'C1B155555BD7B274550C62082DE091AE'

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


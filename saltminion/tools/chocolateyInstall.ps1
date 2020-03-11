$packageName = 'saltminion'

# Update these URLs and checksums when deploying a new version
$url64 = 'https://repo.saltstack.com/windows/Salt-Minion-2019.2.2-Py3-AMD64-Setup.exe'
$checksum64 = 'C30E60057647DE6CF27E6181E1542ABD'
$url = 'https://repo.saltstack.com/windows/Salt-Minion-2019.2.2-Py3-x86-Setup.exe'
$checksum = 'DC1FD28A8CC3E72909E819D147D9211E'

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

$packageParameters = $env:chocolateyPackageParameters
# Default the values
$masterName = ''
$minionName = ''
$minionRunning = 1

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
        Write-Host "You specified a custom Salt-Master name"
        $masterName = $arguments['master']
        $packageArgs['silentArgs'] += " /master=$masterName"
    }

    if ($arguments.ContainsKey("minion")) {
        Write-Host "You specified a custom Salt-Minion name"
        $minionName = $arguments['minion']
        $packageArgs['silentArgs'] += " /minion-name=$minionName"
    }

    if ($arguments.ContainsKey("norunning")) {
        Write-Host "You want Additional Tools installed"
        $minionRunning = 0
        $packageArgs['silentArgs'] += " /start-minion=$minionRunning"
    }
} else {
    Write-Debug "No Package Parameters Passed in, using defaults of /master=salt and /minion=$env:COMPUTERNAME"
}
install-ChocolateyPackage @packageArgs

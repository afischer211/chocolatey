# Joplin Notes and To-Do
# 2018 foo.li systeme + software, afischer211
$ErrorActionPreference = 'Stop';
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version               = '3.4.6'
$packageSearch         = 'Joplin*'
$installerFileName     = 'Joplin-Setup-' + $version + '.exe'
$file          = Join-Path $toolsDir $installerFileName
$installerType = 'exe'
$packageName   = 'joplin'
$url 		   = 'https://github.com/laurent22/joplin/releases/download/v' + $version + '/' + $installerFileName
$checksum      = '7D6A4650EF63D2E1E74771571DA8709F31079A8F9707FC8D2BEC9E9313CF9AC2'
$checksumType  = 'sha256'

$packageArgs = @{
  packageName    = $packageName
  fileType       = $installerType
  softwareName   = $packageSearch
  silentArgs     = '/ALLUSERS=1 /S'
  validExitCodes = @(0)
  url           = $url
  url64bit      = $url
  checksum      = $checksum
  checksumType  = $checksumType
  checksum64    = $checksum
  checksumType64= $checksumType  
}

try {   
    $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
            -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }
	
    if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
        Write-Output $(
        'Joplin ' + $version + ' or greater is already installed. ' +
        'No need to download and install again. Otherwise uninstall first.'
        )
    } else {
        Install-ChocolateyPackage @packageArgs
    }           
} catch {
    throw $_.Exception
}

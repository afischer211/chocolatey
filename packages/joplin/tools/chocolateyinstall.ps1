﻿# Joplin Notes and To-Do
# 2018 foo.li systeme + software, afischer211
$ErrorActionPreference = 'Stop';
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version               = '2.14.19'
$packageSearch         = 'Joplin*'
$installerFileName     = 'Joplin-Setup-' + $version + '.exe'
$file          = Join-Path $toolsDir $installerFileName
$installerType = 'exe'
$packageName   = 'joplin'
$url 		   = 'https://github.com/laurent22/joplin/releases/download/v' + $version + '/' + $installerFileName
$checksum      = '224D963E7E08842911EF206590CA144AC6672EFB4E530D3446C2549C24F4156E'
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

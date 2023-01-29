# Joplin Notes and To-Do
# 2018 foo.li systeme + software, afischer211
$ErrorActionPreference = 'Stop';
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version               = '2.10.4'
$packageSearch         = 'Joplin*'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  file          = Join-Path $toolsDir 'Joplin-Setup-2.10.4.exe'
  softwareName  = $packageSearch
  silentArgs    = '/ALLUSERS=1 /S'
  validExitCodes= @(0)
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
        Install-ChocolateyInstallPackage @packageArgs
    }           
} catch {
    throw $_.Exception
}

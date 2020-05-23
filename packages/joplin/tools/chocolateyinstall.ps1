# Joplin Notes and To-Do
# 2018 foo.li systeme + software, afischer211

$packageName    = 'joplin'
$packageSearch  = 'Joplin*'
$installerType  = 'exe'
$silentArgs     = '/ALLUSERS=1 /S'
$version        = '1.0.214'
$url 			= 'https://github.com/laurent22/joplin/releases/download/v' + $version + '/Joplin-Setup-' + $version + '.exe'
$url64          = $url
$checksum       = 'A52D3B962E7997C212782F5E0CCE131CEF4720C9'
$checksumType   = 'sha1'
$checksum64   	= $checksum
$checksumType64 = $checksumType

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
        Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
                    -checksum $checksum -checksumType $checksumType `
                    -checksum64 $checksum64 -checksumType64 $checksumType64
    }           
} catch {
    throw $_.Exception
}
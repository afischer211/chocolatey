# Kopano DeskApp
# 2017 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'kopano-deskapp-nightly'
$packageSearch  = 'Kopano DeskApp'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.3.18'
$url            = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x86.msi'
$url64          = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x64.msi'
$checksum       = '7A985E70BFA1C0E38ABAE078325AFD9F210F84D6'
$checksumType   = 'sha1'
$checksum64     = 'C36DDEE5B6A83490921584F8B9BD7D0866752BED'
$checksumType64 = $checksumType


try {   
    $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
            -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }

    if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
        Write-Output $(
        'Kopano DeskApp ' + $version + ' or greater is already installed. ' +
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
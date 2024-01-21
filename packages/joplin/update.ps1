Import-Module AU

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
#            "(?i)(^\s*file\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName32)'"
            "(?i)(^.*version\s*=\s*)('.*')"  = "`$1'$($Latest.Version)'"
			"(?i)(^.*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
            "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
        }
	}
}

function global:au_BeforeUpdate() {
	Get-RemoteFiles -Purge -NoSuffix 
}


function global:au_GetLatest {
	# Get latest release information from GitHub
	$gh_latest_page	= Invoke-WebRequest -Uri https://api.github.com/repos/laurent22/joplin/releases/latest -Headers $headers -ContentType "application/json" | ConvertFrom-Json

	# Get version
	$version	= $gh_latest_page.name.trim('v')

	# Get download URL
	$asset		= $gh_latest_page.assets | Where-Object { $_.name -Match 'exe' -and  $_.name -Match 'Setup' }
	$url		= $asset.browser_download_url

	return @{ Version = $version; URL32 = $url; PackageName = 'joplin'}
}

Update-Package -ChecksumFor none

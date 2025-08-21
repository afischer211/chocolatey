# Joplin Package Automation

This repository includes automated updating for the Joplin Chocolatey package using GitHub Actions.

## Overview

The automation workflow (`.github/workflows/update-joplin.yml`) automatically:

1. **Checks for Updates**: Monitors the [Joplin GitHub releases](https://github.com/laurent22/joplin/releases) daily
2. **Updates Package Files**: Automatically updates version, URLs, and checksums
3. **Creates Pull Requests**: Opens PRs with the updated package for review

## How It Works

### Workflow Schedule
- **Daily Check**: Runs every day at 6:00 AM UTC
- **Manual Trigger**: Can be manually triggered from the Actions tab

### Update Process

1. **Setup**: Installs the AU (Automatic Updater) PowerShell module
2. **Check**: Runs `packages/joplin/update.ps1` to check for new releases
3. **Update**: If a new version is found, updates these files:
   - `packages/joplin/tools/chocolateyinstall.ps1` - Version and checksum
   - `packages/joplin/legal/VERIFICATION.txt` - Download URL and checksum
   - `packages/joplin/joplin.nuspec` - Version number and release notes URL

4. **PR Creation**: Creates a pull request with the changes for review

### Files Updated

#### chocolateyinstall.ps1
- `$version` variable updated to latest version
- `$checksum` updated with SHA256 hash of the installer

#### VERIFICATION.txt
- Download URL updated to point to the latest installer
- Checksum updated for verification

#### joplin.nuspec
- `<version>` tag updated
- `<releaseNotes>` URL updated to point to the new release

## AU Framework

The automation uses the [AU (Automatic Updater)](https://github.com/majkinetor/au) PowerShell framework specifically designed for Chocolatey packages.

### Key AU Functions Used

- `au_GetLatest`: Fetches the latest release info from GitHub API
- `au_SearchReplace`: Defines regex patterns to update files
- `au_BeforeUpdate`: Downloads and verifies the installer file
- `Update-Package`: Executes the update process

## Manual Testing

To manually test the update process:

1. Install AU module: `Install-Module AU -Force`
2. Navigate to: `cd packages/joplin`
3. Run update: `.\update.ps1`

## Troubleshooting

### Common Issues

1. **Rate Limiting**: GitHub API has rate limits. The workflow includes retry logic.
2. **Checksum Mismatches**: AU automatically downloads and verifies checksums.
3. **Version Parsing**: The script expects GitHub releases with `v` prefix (e.g., `v3.3.12`).

### Logs

Check the GitHub Actions logs in the repository's Actions tab for detailed execution information.

## Configuration

The workflow can be customized by modifying `.github/workflows/update-joplin.yml`:

- **Schedule**: Change the cron expression for different check frequency
- **Branch Name**: Modify the `branch` parameter in the PR creation step
- **Notification**: Add Slack/Teams notifications on update success/failure

## Security

- Uses GitHub's built-in `GITHUB_TOKEN` for authentication
- No sensitive credentials stored
- AU framework handles secure checksum verification
- All changes go through PR review process before merging
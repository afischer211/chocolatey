# Joplin Package Automation

This repository includes automated updating for the Joplin Chocolatey package using GitHub Actions.

## Overview

The automation includes two workflows:

1. **Update Workflow** (`.github/workflows/update-joplin.yml`):
   - **Checks for Updates**: Monitors the [Joplin GitHub releases](https://github.com/laurent22/joplin/releases) daily
   - **Updates Package Files**: Automatically updates version, URLs, and checksums
   - **Creates Pull Requests**: Opens PRs with the updated package for review

2. **Publishing Workflow** (`.github/workflows/publish-to-chocolatey.yml`):
   - **Detects Changes**: Identifies modified packages when changes are merged
   - **Builds Packages**: Creates .nupkg files using `choco pack`
   - **Publishes to Chocolatey.org**: Automatically pushes packages using secure API key

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

### Publishing Process

After a PR is reviewed and merged to the main branch:

1. **Detection**: Identifies which packages have changed in the merge commit
2. **Build**: Uses `choco pack` to create .nupkg package files
3. **Publish**: Pushes packages to chocolatey.org using stored API key
4. **Cleanup**: Removes temporary .nupkg files after successful publishing

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

The workflows can be customized by modifying their respective files:

### Update Workflow (`.github/workflows/update-joplin.yml`)

- **Schedule**: Change the cron expression for different check frequency
- **Branch Name**: Modify the `branch` parameter in the PR creation step
- **Notification**: Add Slack/Teams notifications on update success/failure

### Publishing Workflow (`.github/workflows/publish-to-chocolatey.yml`)

- **Target Branches**: Modify the `branches` array to change which branches trigger publishing
- **Package Detection**: Adjust the `paths` filter to change which directory changes trigger the workflow
- **Chocolatey Source**: Modify the `--source` parameter to push to different repositories (e.g., private feeds)

## Publishing to Chocolatey.org

The repository includes automated publishing of packages to chocolatey.org when changes are merged to the main branch.

### Publishing Workflow

The `.github/workflows/publish-to-chocolatey.yml` workflow automatically:

1. **Triggers**: Runs when changes are pushed to main/master branch in the packages directory
2. **Detects Changes**: Identifies which packages have been modified
3. **Builds Packages**: Uses `choco pack` to create .nupkg files
4. **Publishes**: Pushes packages to chocolatey.org using `choco push`

### Setting up the Chocolatey API Key

To enable publishing to chocolatey.org, you need to add your Chocolatey API key as a GitHub repository secret:

1. **Get your API key**:
   - Log in to [chocolatey.org](https://chocolatey.org)
   - Go to your account settings
   - Navigate to the API Keys section
   - Copy your API key

2. **Add the secret to GitHub**:
   - Go to your GitHub repository
   - Click on Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `CHOCOLATEY_API_KEY`
   - Value: Your Chocolatey API key
   - Click "Add secret"

### Security Best Practices

- **API Key Storage**: The Chocolatey API key is stored as an encrypted GitHub secret
- **Limited Scope**: The API key only has permissions to push packages to chocolatey.org
- **Automatic Cleanup**: Generated .nupkg files are removed after successful publishing
- **Error Handling**: Workflow fails safely if API key is missing or invalid

### Manual Publishing

To manually trigger publishing:

1. Go to the Actions tab in your GitHub repository
2. Select the "Publish to Chocolatey.org" workflow
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

## Security

- Uses GitHub's built-in `GITHUB_TOKEN` for authentication
- Chocolatey API key stored as encrypted GitHub repository secret
- AU framework handles secure checksum verification
- All changes go through PR review process before merging
- Published packages are automatically verified by Chocolatey moderators
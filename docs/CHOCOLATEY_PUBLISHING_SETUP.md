# Chocolatey Package Publishing Setup

This guide explains how to securely configure automatic publishing of Chocolatey packages to chocolatey.org using GitHub Actions.

## Prerequisites

- A verified account on [chocolatey.org](https://chocolatey.org)
- Permission to publish packages (you must be the package maintainer)
- Repository access to manage GitHub secrets

## Step 1: Obtain Your Chocolatey API Key

1. **Log in to Chocolatey.org**:
   - Go to [chocolatey.org](https://chocolatey.org)
   - Sign in with your account

2. **Navigate to API Keys**:
   - Click on your profile (top right)
   - Select "Account Settings"
   - Go to the "API Keys" tab

3. **Generate or Copy API Key**:
   - If you don't have an API key, click "Create New API Key"
   - Give it a descriptive name (e.g., "GitHub Actions - YourRepository")
   - Copy the generated API key (keep this secure!)

## Step 2: Add API Key to GitHub Repository

1. **Navigate to Repository Settings**:
   - Go to your GitHub repository
   - Click on the "Settings" tab
   - Select "Secrets and variables" → "Actions"

2. **Create New Repository Secret**:
   - Click "New repository secret"
   - **Name**: `CHOCOLATEY_API_KEY`
   - **Value**: Paste your Chocolatey API key
   - Click "Add secret"

## Step 3: Verify Workflow Configuration

The publishing workflow (`.github/workflows/publish-to-chocolatey.yml`) is automatically configured and will:

- **Trigger**: When changes are pushed to main/master branch in the `packages/` directory
- **Detect**: Which packages have been modified
- **Build**: Create .nupkg files using `choco pack`
- **Publish**: Push packages to chocolatey.org using your API key

## Security Best Practices

### API Key Management

- **Never commit API keys to source code**
- **Use GitHub Secrets**: API keys are encrypted and only accessible to authorized workflows
- **Limited scope**: API keys should only have package publishing permissions
- **Regular rotation**: Consider rotating API keys periodically

### Repository Settings

- **Branch protection**: Enable branch protection rules for main/master branch
- **Required reviews**: Require PR reviews before merging changes
- **Status checks**: Ensure CI/CD checks pass before allowing merges

### Workflow Security

- **Minimal permissions**: The workflow uses only necessary GitHub permissions
- **Error handling**: Workflow fails safely if API key is missing or invalid
- **Cleanup**: Generated package files are automatically removed after publishing
- **Audit trail**: All publishing actions are logged in GitHub Actions

## Testing the Setup

### Manual Test

1. **Create a test change**:
   - Make a minor update to a package (e.g., update description in .nuspec)
   - Create a pull request
   - Merge the PR to main branch

2. **Monitor the workflow**:
   - Go to Actions tab in your repository
   - Watch the "Publish to Chocolatey.org" workflow run
   - Check logs for any errors

### Troubleshooting Common Issues

1. **"API key not configured" error**:
   - Verify the secret is named exactly `CHOCOLATEY_API_KEY`
   - Check that the secret value was pasted correctly

2. **"Package already exists" error**:
   - Ensure package version has been incremented
   - Check if package was already published manually

3. **"Access denied" error**:
   - Verify you're a maintainer of the package on chocolatey.org
   - Check that API key has publishing permissions

## Advanced Configuration

### Custom Chocolatey Sources

To publish to private Chocolatey repositories, modify the workflow:

```yaml
choco push $nupkgFile --source https://your-private-feed.com/ --api-key $env:CHOCOLATEY_API_KEY --confirm
```

### Multiple API Keys

For publishing to multiple sources, add additional secrets:

- `CHOCOLATEY_API_KEY_PRIVATE`
- `CHOCOLATEY_API_KEY_INTERNAL`

Then use conditionally in the workflow.

### Notification Integration

Add Slack/Teams notifications on publishing success/failure:

```yaml
- name: Notify on Success
  if: success()
  # Add your notification step here
```

## Maintenance

### Regular Tasks

- **Monitor workflows**: Check GitHub Actions regularly for failures
- **Update dependencies**: Keep workflow actions updated (e.g., `actions/checkout@v4`)
- **Review API key usage**: Monitor API key usage on chocolatey.org
- **Test periodically**: Occasionally test the full workflow end-to-end

### Security Updates

- **Rotate API keys**: Update API keys if compromised or periodically
- **Review permissions**: Regularly audit who has access to repository secrets
- **Update workflows**: Keep workflow files updated with security best practices

## Support

If you encounter issues:

1. **Check workflow logs**: GitHub Actions provides detailed logs
2. **Chocolatey documentation**: Visit [chocolatey.org/docs](https://chocolatey.org/docs)
3. **GitHub repository issues**: Create an issue in this repository for workflow-specific problems
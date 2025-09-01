# chocolatey

I have overtaken the maintenance from Peter, especially for the package joplin.

## Automation

The Joplin package includes full automation via GitHub Actions:

- **Update Automation**: Daily checks for new releases and creates pull requests with updates
- **Publishing Automation**: Automatically publishes packages to chocolatey.org when changes are merged

See [docs/JOPLIN_AUTOMATION.md](docs/JOPLIN_AUTOMATION.md) for automation details.

## Publishing Setup

To enable automatic publishing to chocolatey.org, see [docs/CHOCOLATEY_PUBLISHING_SETUP.md](docs/CHOCOLATEY_PUBLISHING_SETUP.md) for detailed setup instructions including how to securely configure the required API key.

**This repository will be archived soon, please take a look into the more intensively maintained repository afischer211/my-chocolatey.**

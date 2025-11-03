# TeamCity Build Config Searcher

Fuzzy search all build configurations in TeamCity.

## Setup

1. Install dependencies:

   ```bash
   npm install
   ```

2. Set your TeamCity credentials:
   - TeamCity Token: Your personal access token
   - TeamCity URL: Your TeamCity server URL (default: https://teampicnic.teamcity.com)

3. Run the plugin in development mode:
   ```bash
   npm run dev
   ```

## Usage

1. **Refresh Build Configuration List**: Fetch all build configurations from TeamCity
2. **Search Build Configurations**: Fuzzy search through cached build configurations

## Commands

- `Search Build Configurations`: Open the search interface
- `Refresh Build Configuration List`: Fetch latest build configs from TeamCity API

## Dump Script

You can also use the included `dump-build-configs.sh` script to fetch build configurations:

```bash
export TC_PAT="your-token"
./dump-build-configs.sh
```

# Gitleaks

This script installs the Gitleaks tool, which is used for detecting and preventing hard-coded secrets such as passwords, API keys, and tokens in Git repositories.

To use this installation script, grant it executable permissions and execute:

```bash
chmod +x install.sh
./install.sh
```

This script will automatically create the pre-commit hook file, add the necessary script to it, and enable the gitleaks check using git config.

### Output

```bash
gitleaks detect -v

   ○
   │╲
   │ ○
   ○ ░
   ░    gitleaks

6:36PM INF 36 commits scanned.
6:36PM INF scan completed in 140ms
6:36PM INF no leaks found
```

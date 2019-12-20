# SIMPLE MARKDOWN DIARY
Simple scripts to initialize and maintain an diary which entries are markdown files. The diary is intended to be used inside a git repo so the changes the history of the diary is saved.

The scripts have been tested on Linux (using bash) and Windows (using Powershell). It is possible that it will also work in Mac OS.

## How-To

1. If a git repository is not present: `git init`.
2. Every new day:
   - In Linux/Mac OS: `./new_day.sh`.
   - In Windows: `.\new_day.ps1`.
3. At the end of the day: 
   - In Linux/Mac OS: `./end_day.sh`.
   - In Windows: `.\end_day.ps1`.
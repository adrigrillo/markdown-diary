$BASE_PATH = "."
$FILE_NAME = Get-Date -Format yyyyMMdd
$MONTH_NAME = Get-Date -UFormat %B

# Check for the last file
$found_file = $false
$index = 1

while (-Not($found_file)) {
    # Get file name and folder
    $PREV_FILE_NAME = (Get-Date).AddDays(-$index).ToString("yyyyMMdd")
    $PREV_MONTH_NAME = (Get-Date).AddDays($day_to_previous).Month
    $PREV_MONTH_NAME = (Get-Culture).DateTimeFormat.GetMonthName($PREV_MONTH_NAME)
    # Check that exist
    $prev_file_path = $BASE_PATH + "\" + $PREV_MONTH_NAME + "\" + $PREV_FILE_NAME + ".md"
    $found_file = Test-Path $prev_file_path
    if ($found_file) {
        Write-Host "Found file: " $prev_file_path
        break
    }
    # Stop after a week
    $index = $index + 1
    if ($index -gt 7){
        break
    }
}

# Path will be: month_name/yearmonthday.md
$file_path = $BASE_PATH + "\" + $MONTH_NAME + "\" + $FILE_NAME + ".md"

# Creates the file
New-Item $file_path -ItemType File -Force

# Set the content
Set-Content $file_path -Value (Get-Date -UFormat "# %A, %e.%m.%Y")
Add-Content $file_path -Value "## Diary`n"
Add-Content $file_path -Value "## Tasks`n"
Add-Content $file_path -Value "## Papers to read`n"
Add-Content $file_path -Value "## Questions`n"
Add-Content $file_path -Value "## Utils`n"

if ($found_file) {
    # Get line of tasks previous day
    $task_line = (Select-String -Path $prev_file_path -Pattern '## Tasks').LineNumber
    $papers_line = (Select-String -Path $prev_file_path -Pattern '## Papers to read').LineNumber - 2
    $prev_tasks = (Get-Content $prev_file_path)[$task_line..$papers_line]

    # Get line of task to add the previous tasks
    $line = (Select-String -Path $file_path -Pattern '## Tasks').LineNumber
    $file_content = Get-Content $file_path
    $file_content[$line] = $prev_tasks
    $file_content | Set-Content $file_path

    # Remove task completed
    (Get-Content $file_path) -notmatch '- \[x\]' | Set-Content $file_path
}

# open new file
Start-Process $file_path

# Commit file in git
$git_file_name = $MONTH_NAME + "/" + $FILE_NAME + ".md"
$git_message = "Beginning of " + (Get-Date -Format "dddd, dd/MM/yyyy")

git add $git_file_name
git commit -m $git_message
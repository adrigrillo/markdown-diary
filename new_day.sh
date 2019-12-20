#!/bin/bash
# Set language to english for the folder creation
default_lang=$LANG
LANG=english

base_path=/home/adrigrillo/Documents/repos/fka-diary
cd "$base_path" || exit

file_name=$(date +"%Y%m%d")
month_name=$(date +"%B")

# Check for the last file
i=1
found_file=0
while [ $found_file -eq 0 ]; do
    prev_month_name=$(date -d "-$i days" +"%B")
    prev_file_name=$(date -d "-$i days" +"%Y%m%d")
    if test -f "$base_path/$prev_month_name/$prev_file_name.md"; then
        echo "$base_path/$prev_month_name/$prev_file_name.md exist."
        last_file="$base_path/$prev_month_name/$prev_file_name.md"
        found_file=1
        break
    fi
    if [ $i -gt 7 ]; then
        echo "File not found in the previous week."
        break
    fi
    i=$((i + 1))
done

if [ $found_file -eq 1 ]; then
    # Look and save the tasks to copy th following day.
    task_line=$(($(grep -n "## Tasks" "$last_file"| head -n 1 | cut -d: -f1) + 1))
    papers_line=$(($(grep -n "## Papers to read" "$last_file" | head -n 1 | cut -d: -f1) - 1))
    task=$(sed -n "$papers_line q; $task_line,$papers_line p" "$last_file")
else
    task=''
fi

# Check the directory exist.
if [ ! -d "$base_path/$month_name" ]; then
    mkdir -p "$base_path/$month_name"
fi

new_file="$base_path/$month_name/$file_name.md"

# Generate the document with old tasks
cat <<EOF > "$new_file"
# $(date "+%A, %d.%m.%Y")
## Diary

## Tasks
$task

## Papers to read

## Questions

## Utils
EOF

if [ $found_file -eq 1 ]; then
    # Removes finished task of the previous day
    sed -i '/- \[x\]/d' "$new_file"
fi

# Open file
codium "$new_file"

# # Commit file in git
git add "$new_file"
git commit -m "Beginning of $(date +"%A, %d/%m/%Y")"

# SET LANGUAGE BACK TO DEFAULT!!
LANG=$default_lang

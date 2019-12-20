#!/bin/bash
firefox http://studiary.ika.rwth-aachen.de/

# Set language to english for the folder creation
default_lang=$LANG
LANG=english

base_path=/home/adrigrillo/Documents/repos/fka-diary/
cd "$base_path" || exit

file_name=$(date +"%Y%m%d")
month_name=$(date +"%B")

new_file="$base_path$month_name/$file_name.md"

# Commit file in git
git add "$new_file"
git commit -m "End of $(date +"%A, %d/%m/%Y")"
git push

# SET LANGUAGE BACK TO DEFAULT!!
LANG=$default_lang


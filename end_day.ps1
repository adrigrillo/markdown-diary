$BASE_PATH = "D:\ablage\grillo\diary"
$FILE_NAME = Get-Date -Format yyyyMMdd
$MONTH_NAME = Get-Date -UFormat %B

Set-Location $BASE_PATH
$git_file_name = $MONTH_NAME + "/" + $FILE_NAME + ".md"
$git_message = "End of " + (Get-Date -Format "dddd, dd/MM/yyyy")

# Log in studiary
Start-Process "http://studiary.ika.rwth-aachen.de/"

git add $git_file_name
git commit -m $git_message
git push
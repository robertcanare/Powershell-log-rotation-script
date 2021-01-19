# Windows Server Log rotation script

# Get the current date 
$current_date = $(Get-Date -Format "MM-dd-yyyy-HHmm")
$current_year = $(Get-Date -Format "yyyy")

# Location to the root directory for the log files
$root_location = "C:\Users\rcanare\Desktop\test-logs-directory\"

# File extention
$file_extention = "*.log"

# By days
$compress_duration = "-6"
$delete_archived = "-365"

# Scrape each directory
$directory = $(Get-ChildItem "$root_location" -Recurse -Directory)
foreach ($d in $directory) {
    $location = $d.FullName + "\"
    $files = $(Get-ChildItem "$location" -Recurse -File -Filter $file_extention | ? {$_.CreationTime -ge (Get-Date).AddDays(-6)})
    foreach ($f in $files) {
    $outfile = $f.FullName
    md $location$current_date-$current_year
    mv $outfile $location$current_date-$current_year
    .\Rar.exe a $location$current_date-$current_year.zip $location$current_date-$current_year ; Remove-Item -Path $location$current_date-$current_year -Recurse -Force

    # Deleting old compressed files older than $delete_archived
    Get-ChildItem "$location" -Recurse -File -Filter "*.zip" | Where CreationTime -lt  (Get-Date).AddDays($delete_archived) | Remove-Item -Force
                        }
                            }

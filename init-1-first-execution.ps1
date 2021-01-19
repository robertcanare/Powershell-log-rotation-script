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

# Scraping each directory
$directory = $(Get-ChildItem "$root_location" -Recurse -Directory)
foreach ($d in $directory) {
    $location = $d.FullName + "\"
    for ($i = 1; $i -le 13; $i++) { 
    $month = $((Get-Culture).DateTimeFormat.GetMonthName($i)) 
    $two_digits = $("{0:D2}" -f $i)
    $creation_time = "$two_digits/30/2020 12:42 AM"
    $file = "$location$month-$current_year.zip"


    # Compression for the PS version 4.0
    $files = $(Get-ChildItem "$location" -Recurse -File -Filter $file_extention | ?{$_.CreationTime.Month -eq $i}) 

    foreach ($f in $files) {
    $outfile = $f.FullName 
    md $location$month-$current_year

    mv $outfile $location$month-$current_year
    .\Rar.exe a $location$month-$current_year.zip $location$month-$current_year ; Remove-Item -Path $location$month-$current_year -Recurse -Force ; (Get-ChildItem $location$month-$current_year.zip ).CreationTime = $creation_time 
                         }


                                } 
                        }

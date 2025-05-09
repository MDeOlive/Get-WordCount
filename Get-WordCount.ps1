Param(
    [parameter(Mandatory = $True)][System.IO.FileInfo]$Path
)

$fileContent = get-content -Path $Path
# Count the number of lines in the file
$lineCount = $fileContent.Count

# making everything lowercase for easier comparison
$file = $fileContent.tolower()

# -replace parameter removes any characters that aren't letters, space characters, or apostrophes
# -split splits the string where the delimiter is one or more spaces
# -match matches only the results that are non-whitespace
# the result is an array with all the words in the file
$file = $file -replace "[^a-zA-Z\s']", '' -split '\s+' -match '\S'

# new array without duplicates for iteration
$unique = $file | Select-Object -Unique 

# empty array for adding custom objects that will contain each word and count
$wordlist = @()

Foreach ($word in $unique){

    # creating a custom object with "Word" and "Count" properties. The count is calculated where the count value is assigned
    $wordcount = New-Object -TypeName psobject
    $wordcount | Add-Member -MemberType NoteProperty -Name Word -Value $word
    $wordcount | Add-Member -MemberType NoteProperty -Name Count -Value ($file | Where-Object {$_ -eq $word}).count
    $wordlist += $wordcount

}

# printing the line count
Write-Output "Total Lines: $lineCount"

# printing the results in order of most used to least used
$wordlist | Sort-Object Count -Descending
﻿Param(
    [parameter(Mandatory = $True)][System.IO.FileInfo]$Path
)

$file = get-content -Path $Path

# making everything lowercase for easier comparison
$file = $file.tolower()

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

    # creating a custom object with "Word" and "Count" properties. The count is calculated right where the count value is assigned
    $wordcount = New-Object -TypeName psobject
    $wordcount | Add-Member -MemberType NoteProperty -Name Word -Value $word
    $wordcount | Add-Member -MemberType NoteProperty -Name Count -Value ($file | Where-Object {$_ -eq $word}).count
    $wordlist += $wordcount

}

$wordlist | Sort-Object Count -Descending
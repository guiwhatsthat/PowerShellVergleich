$input1 = Get-Content -Path "C:\scripts\inputdata\woerter2.txt"
$input2 = Get-Content -Path  "C:\scripts\inputdata\phoneCodeINputfile.txt"

function Char-To-Digit($ch) {
    #switch ($ch.ToLower()) {
    switch ($ch) { #Powershell ist nicht case sensitiv
        {$_ -eq 'e'} { return 0 }
        {$_ -eq 'j' -or $_ -eq 'n' -or $_ -eq 'q'} { return 1 }
        {$_ -eq 'r' -or $_ -eq 'w' -or $_ -eq 'x'} { return 2 }
        {$_ -eq 'd' -or $_ -eq 's' -or $_ -eq 'y'} { return 3 }
        {$_ -eq 'f' -or $_ -eq 't'} { return 4 }
        {$_ -eq 'a' -or $_ -eq 'm'} { return 5 }
        {$_ -eq 'c' -or $_ -eq 'i' -or $_ -eq 'v'} { return 6 }
        {$_ -eq 'b' -or $_ -eq 'k' -or $_ -eq 'u'} { return 7 }
        {$_ -eq 'l' -or $_ -eq 'o' -or $_ -eq 'p'} { return 8 }
        {$_ -eq 'g' -or $_ -eq 'h' -or $_ -eq 'z'} { return 9 }
        default { throw "Invalid input: not a digit: $ch" }
    }
}

function Word-To-Number($word) {
    $n = 0
    foreach ($ch in $word.ToCharArray()) {
        if ($ch -match "[a-zA-Z]") {
            $n = $n * 10 + (Char-To-Digit $ch)
        }
    }
    return $n
}

function Load-Dict($words) {
    $dict = @{}
    foreach ($word in $words) {
        $key = Word-To-Number $word
        if (-not $dict.ContainsKey($key)) {
            $dict[$key] = @()
        }
        $dict[$key] += $word
    }
    return $dict
}

function Print-Solution($num, $words) {
    $output = "$($num): "
    foreach ($word in $words) {
        $output += "$word "
    }
    Write-Output $output.TrimEnd()
}

function Print-Translations($num, $digits, $start, $words, $dict) {
    if ($start -ge $digits.Length) {
        Print-Solution $num $words
        return
    }

    $n = 0
    $foundWord = $false
    for ($i = $start; $i -lt $digits.Length; $i++) {
        $n = $n * 10 + $digits[$i]
        if ($dict.ContainsKey($n)) {
            foreach ($word in $dict[$n]) {
                $foundWord = $true
                $newWords = $words.Clone()
                $newWords += $word
                Print-Translations $num $digits ($i + 1) $newWords $dict
            }
        }
    }

    if (-not $foundWord -and ($words.Count -eq 0 -or -not ($words[-1] -match "^\d+$"))) {
        $newWords = $words.Clone()
        $newWords += $n.ToString()
        Print-Translations $num $digits ($start + 1) $newWords $dict
    }
}

# Dateinamen
$a = Load-Dict $input1
$b = $input2
foreach ($line in $b) {
    $num = $line.Trim()
    $digits = $num -split '' | Where-Object { $_ -match '\d' }
    Print-Translations $num $digits 0 @() $a
}

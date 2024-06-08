$input = Get-Content -Path "C:\scripts\inputdata\Combinations_of_ascending_and_descending_two_sub_arrays-input20000.txt"

class MergeSort {

    static Merge($theArray, $tempArray, $leftPos, $rightPos, $rightEnd) {
        $leftEnd = $rightPos - 1
        $tmpPos = $leftPos
        $numElements = $rightEnd - $leftPos + 1

        while (($leftPos -le $leftEnd) -and ($rightPos -le $rightEnd)) {
            if ($theArray[$leftPos].CompareTo($theArray[$rightPos]) -le 0) {
                $tempArray[$tmpPos++] = $theArray[$leftPos++]
            }
            else {
                $tempArray[$tmpPos++] = $theArray[$rightPos++]
            }
        }

        while ($leftPos -le $leftEnd) { $tempArray[$tmpPos++] = $theArray[$leftPos++] }
        while ($rightPos -le $rightEnd) { $tempArray[$tmpPos++] = $theArray[$rightPos++] }

        for ($i = 0; $i -lt $numElements; $i++, $rightEnd--) {
            $theArray[$rightEnd] = $tempArray[$rightEnd]
        }
    }

    static Sort($theArray) {
        $tempArray = New-Object Object[] $theArray.Count
        [MergeSort]::Sort($theArray, $tempArray, 0, ($theArray.Count - 1))
    }

    static Sort($theArray, $tempArray, $left, $right) {
        if ($left -lt $right) {

            $center = [Math]::Floor(($left + $right) / 2)

            [MergeSort]::Sort($theArray, $tempArray, $left, $center)
            [MergeSort]::Sort($theArray, $tempArray, ($center + 1), $right)

            [MergeSort]::Merge($theArray, $tempArray, $left, ($center + 1), $right)
        }
    }
}


[MergeSort]::Sort($input)

$input = Get-Content -Path "C:\scripts\inputdata\Combinations_of_ascending_and_descending_two_sub_arrays-input20000.txt"

class QuickSort {
    static Sort($targetList, $left, $right) {
        $i=$left
        $j=$right
        $pivot = $targetList[($left+$right)/2]

        while($i -le $j) {
            while($targetList[$i] -lt $pivot -and $i -lt $right) {$i++}
            while($targetList[$j] -gt $pivot -and $j -gt $left) {$j--}

            if($i -le $j) {
                $tmp = $targetList[$i]
                $targetList[$i]=$targetList[$j]
                $targetList[$j]=$tmp

                $i++
                $j--
            }
        }

        if($left -lt $j) {[QuickSort]::Sort($targetList, $left, $j)}
        if($i -lt $right) {[QuickSort]::Sort($targetList, $i, $right)}
    }
}


[QuickSort]::Sort($input, 0, $input.Count-1)
$h1 = @{a = 1; c = 3; r = 6; d = 7}
$h2 = @{c = 3; b = 4; d = 7; s = 9}


Function Merge-Hashtables {
    $Output = @{}
    ForEach ($Hashtable in ($Input + $Args)) {
        If ($Hashtable -is [Hashtable]) {
            ForEach ($Key in $Hashtable.Keys) {$Output.$Key = $Hashtable.$Key}
        }
    }
    $Output.GetEnumerator() | Sort-Object Name
}

$h1, $h2 | Merge-Hashtables
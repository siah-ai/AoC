$start = Get-Date
$pinput = Get-Content .\input.txt
$tinput = Get-Content .\tinput.txt
$p1 = 0
$p2 = 0

function Test-IsSafe([Parameter(Mandatory=$true)][array]$numArray){
    $increasing = $true
    $decreasing = $true
    
    For($i = 0; $i -lt $numArray.Count-1; $i++){
        if([int]$numArray[$i] -le [int]$numArray[$i+1]) {
            $decreasing = $false
        }
        if([int]$numArray[$i] -ge [int]$numArray[$i+1]) {
            $increasing = $false
        }
    }

    if($increasing -or $decreasing){
        $numArray = $numArray | Sort -Property {[int]$_}
        For($i = 0; $i -lt $numArray.Count-1; $i++){
            [int]$diff = [int]$numArray[$i+1]-[int]$numArray[$i]
            if([int]$diff -gt 3 -or [int]$diff -le 0){
                return $false
            }
        }
        return $true
    }
    return $false
}

ForEach($line in $pinput){
    $split = $line.split(' ')
    if(Test-IsSafe -numArray $split){
        $p1++
        $p2++
    }else{
        $passingPermutation = $false
        For($i = 0; $i -lt $split.Count; $i++){
            [System.Collections.ArrayList]$tempArray = $split.Clone()
            [System.Collections.ArrayList]$tempArray.RemoveAt($i)
            if(Test-IsSafe -numArray $tempArray){
                $passingPermutation = $true
            }
        }
        if($passingPermutation){
            $p2++
        }
    }
}

Write-Host "Part 1: $p1"
Write-Host "Part 1: $p2"
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
$start = Get-Date
$pinput = Get-Content .\input.txt
$tinput = Get-Content .\tinput.txt

function Get-LeftRightDistribution($numberArray){
    [System.Collections.ArrayList]$split = $numberArray.split(',')
    $initialGrouping = @{left = @(); right= @(); center= @($split[0])}
    for($i=1;$i-lt $split.count; $i++){
        if($rulemap.b.$($split[0]) -contains $split[$i]){
            $initialGrouping.left += $split[$i]
        }elseif($rulemap.a.$($split[0]) -contains $split[$i]){
            $initialGrouping.right += $split[$i]
        }else{
            $num = $split[0]
            $split.RemoveAt(0)
            $split.Insert($split.Count,$num)
            $initialGrouping = @{left = @(); right= @(); center= @($split[0])}
            $i=0
        }
    }
    return $initialGrouping
}
function Get-MidPageSum($rules,$books){
    $obj = @{correct=0;incorrect=0}
    $RuleMap = @{b=@{};a=@{}}
    ForEach($r in $rules){
        $split = $r.split('|')
        [array]$RuleMap.'a'."$($split[0])" += $split[1]
        [array]$RuleMap.'b'."$($split[1])" += $split[0]
    }
    $badbooks = @()
    $count=1
    ForEach($b in $books){
        Write-Host "Sorting book $count of $($books.count)"
        $split = $b.split(',')
        $Success = $true
        For($x = 0; $x -lt $split.count; $x++){
            For($y = $x+1; $y -lt $split.count; $y++){
                if($RuleMap.b.$($split[$x]) -contains $split[$y]){
                    $Success = $false
                }
            }
        }
        if($Success){
            $obj.correct += $split[$([math]::Floor((($Split.count)/2)))]
        }else{
            $badbooks += $b
        }
        $count++
    }
    $count = 1
    ForEach($b in $badbooks){
        [System.Collections.ArrayList]$split = $b.split(',')
        $Success = $true
        Write-Host "Processing bad book $count of $($badbooks.count)"

        $initialGrouping = Get-LeftRightDistribution -numberArray $split
        $retrycount = 0
        while ($retrycount -lt 25 -and ($initialGrouping.left.count -le $([math]::Floor((($Split.count)/4))) -or $initialGrouping.right.count -le $([math]::Floor((($Split.count)/4))))){ #($initialGrouping.left.Count/$initialGrouping.right.count -lt 0.5 -or $initialGrouping.left.Count/$initialGrouping.right.count -gt 2){
            [System.Collections.ArrayList]$split = $initialGrouping.left + $initialGrouping.right + $initialGrouping.center
            $initialGrouping = Get-LeftRightDistribution -numberArray $split
            $retrycount++
        }

        [System.Collections.ArrayList]$split = $initialGrouping.left.Clone()
        For($x = 0; $x -lt $split.count; $x++){
            For($y = $x+1; $y -lt $split.count; $y++){
                if($RuleMap.b.$($split[$x]) -contains $split[$y]){
                    $num = $split[$y]
                    $split.RemoveAt($y)
                    $split.Insert(0,$num)
                    $x=-1
                    break
                }
            }
        }
        $initialGrouping.left = $split
        [System.Collections.ArrayList]$split = $initialGrouping.right.Clone()
        For($x = 0; $x -lt $split.count; $x++){
            For($y = $x+1; $y -lt $split.count; $y++){
                if($RuleMap.b.$($split[$x]) -contains $split[$y]){
                    $num = $split[$y]
                    $split.RemoveAt($y)
                    $split.Insert(0,$num)
                    $x=-1
                    break
                }
            }
        }
        $initialGrouping.right = $split
        $split = $initialGrouping.left + $initialGrouping.center + $initialGrouping.right
        $obj.incorrect += $split[$([math]::Floor((($Split.count)/2)))]
        $count++
    }


    return $obj
}

$rules = $pinput[0..$($pinput.IndexOf('')-1)]
$Books = $pinput[$($pinput.IndexOf('')+1)..$($pinput.length-1)]

$answers = Get-MidPageSum -rules $pinputR -books $pinputB

Write-Host "Part 1: $($answers.correct)"
Write-Host "Part 2: $($answers.incorrect)"
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
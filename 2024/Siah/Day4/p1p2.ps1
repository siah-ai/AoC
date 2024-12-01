$start = Get-Date
$pinput = Get-Content .\input.txt
$tinput = Get-Content .\tinput.txt

function Get-HorizontalMatches($crosswordLine,$searchWord){
    $count = 0
    $reverseSearchWord = $searchWord.ToCharArray()
    [array]::Reverse($reverseSearchWord)
    $reverseSearchWord = -join $reverseSearchWord
    $count += ($crosswordLine | sls "$searchWord" -A).Matches.Count
    $count += ($crosswordLine | sls "$reverseSearchWord" -A).Matches.Count
    return [int]$count
}

function Get-CrosswordSolutionCount($crosswordText, $p1SearchWord, $p2SearchWord){
    $counts = @{p1=0;p2=0}
    $h = $crosswordText.count
    $l = $crosswordText[0].length

    if($p1SearchWord){
        For($x = 0; $x -lt $l; $x++){
            $counts.p1 += Get-HorizontalMatches -crosswordLine $(-join $crosswordText[0..$($h-1)].Substring($x,1)) -searchWord $p1SearchWord
            $paths = @{t1='';t2='';t3='';t4=''}
            For($y = 0; $y -le $x; $y++){
                $paths.t1 += $crosswordText[$y][$x-$y]
                $paths.t4 += $crosswordText[$y][$l-$x+$y-1]
                if($x -lt $($l-1)){
                    $paths.t3 += $crosswordText[$l-$x+$y-1][$y]
                    $paths.t2 += $crosswordText[$l-$x+$y-1][$l-$y-1]
                }
            }
            $paths.keys | % {$counts.p1 += Get-HorizontalMatches -crosswordLine $paths."$_" -searchWord $p1SearchWord}

            if($x -gt 0 -and $x -lt $l-1 -and $p2SearchWord){
                For($y = 1; $y -lt $h-1; $y++){
                    if($crosswordText[$x][$y] -eq 'A'){
                        if((Get-HorizontalMatches -crosswordLine $($crosswordText[$x-1][$y-1]+$crosswordText[$x][$y]+$crosswordText[$x+1][$y+1]+$crosswordText[$x-1][$y+1]+$crosswordText[$x][$y]+$crosswordText[$x+1][$y-1]) -searchWord $p2SearchWord) -eq 2){
                            $counts.p2++
                        }
                    }
                }
            }
        }
        $crosswordText | % {$counts.p1 += Get-HorizontalMatches -crosswordLine $_ -searchWord $searchWord}
    }
    return $counts
}

$answers = Get-CrosswordSolutionCount -crosswordText $pinput -p1SearchWord 'XMAS' -p2SearchWord 'MAS'

Write-Host "Part 1: $($answers.p1)"
Write-Host "Part 2: $($answers.p2)"
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
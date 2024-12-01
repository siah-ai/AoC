$start = Get-Date
$pinput = Get-Content .\input.txt
[array]$Column1 = @()
[array]$Column2 = @()
$gap = 0
$simscores = 0

ForEach($set in $pinput){
    $split = $set.split(' ')
    $Column1 += [int]$split[0]
    $Column2 += [int]$split[$split.count-1]
}

$Column1 = $Column1 | Sort
$Column2 = $Column2 | Sort

For($i = 0; $i -lt $Column1.count; $i++){
    if($Column1[$i] -gt $Column2[$i]){
        $gap = $gap+$($Column1[$i]-$Column2[$i])
    }else{
        $gap = $gap+$($Column2[$i]-$Column1[$i])
    }
}

ForEach($num in $Column1){
    $simscores = $simscores+$($num*$(($Column2 | where {$_ -eq $num}).count))
}

Write-Host "Part 1: $gap"
Write-Host "Part 2: $simscores"
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
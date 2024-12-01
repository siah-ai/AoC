$start = Get-Date
$pinput = Get-Content .\input.txt

Write-Host "Part 1: $gap"
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
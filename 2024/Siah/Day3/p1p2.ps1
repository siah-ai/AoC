$d=1;(gc .\input.txt | sls "mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)" -A).Matches | % {$d = !($_ -match 'm') ? $_ -match "n" ? 0 : 1 : $d;$n=([string]$_ -replace "[^\d,]").split(',') | % {[int]$_};$z=$n[0]*$n[1];$b += $d ? $z : 0;$a+=$z};$a;$b
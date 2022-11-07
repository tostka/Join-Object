#*------v _CommonCode.ps1 v------
$JoinCommand = Get-Command Join-Object
Copy-Command -Command $JoinCommand -Name InnerJoin-Object -Default @{JoinType = 'Inner'}; Set-Alias InnerJoin InnerJoin-Object
Copy-Command -Command $JoinCommand -Name LeftJoin-Object  -Default @{JoinType = 'Left'};  Set-Alias LeftJoin  LeftJoin-Object
Copy-Command -Command $JoinCommand -Name RightJoin-Object -Default @{JoinType = 'Right'}; Set-Alias RightJoin RightJoin-Object
Copy-Command -Command $JoinCommand -Name FullJoin-Object  -Default @{JoinType = 'Full'};  Set-Alias FullJoin  FullJoin-Object
Copy-Command -Command $JoinCommand -Name CrossJoin-Object -Default @{JoinType = 'Cross'}; Set-Alias CrossJoin CrossJoin-Object
Copy-Command -Command $JoinCommand -Name Update-Object    -Default @{JoinType = 'Left'; Property = {{If ($Null -ne $RightIndex) {$Right.$_} Else {$Left.$_}}}}; Set-Alias Update Update-Object
Copy-Command -Command $JoinCommand -Name Merge-Object     -Default @{JoinType = 'Full'; Property = {{If ($Null -ne $RightIndex) {$Right.$_} Else {$Left.$_}}}}; Set-Alias Merge  Merge-Object
#*------^ END _CommonCode.ps1 ^------

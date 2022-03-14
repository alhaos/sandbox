Param (
    [string]$TargetProcessName = 'notepad'
)

Set-StrictMode -Version 'latest'

$FirstDayOfMonth = get-date -Day 1 -Hour 0 -Minute 0 -Second 0
$TargetProcessStartTime = (Get-Process $TargetProcessName -ErrorAction SilentlyContinue)?.StartTime 
if (!$TargetProcessStartTime) {
    Write-Host "Cannot find a process with the name $TargetProcessName"
    exit 1
}
$TargetTimeStamp = $FirstDayOfMonth -gt $TargetProcessStartTime ? $FirstDayOfMonth : $TargetProcessStartTime
$TimeSpan = [datetime]::Now - $TargetTimeStamp
$msg = "{0} process duration this month is: {1:n0} seconds" -f $TargetProcessName , $TimeSpan.TotalSeconds
Write-Host $msg
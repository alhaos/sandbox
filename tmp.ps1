$DebugPreference = 'Continue'
[enum]::GetValues([System.DayOfWeek]).ForEach{
    Write-Debug "$([int]$_) $_"
}
$ht = @{
    key1 = 'value'
}

$DebugPreference = 'continue'

Set-StrictMode -Off

Write-Debug  ("[{0}], [{1}]" -f $ht.key1, $ht.key2)

Set-StrictMode -Version 2.0

Write-Debug  ("[{0}], [{1}]" -f $ht.key1, $ht.key2)


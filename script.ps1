using namespace System.Data.Sqlite
using namespace System.Data
using namespace System.IO

using assembly .\lib\System.Data.SQLite.dll 

Set-StrictMode -version 2.0

$Global:conf = Import-PowerShellDataFile .\conf.psd1

$ErrorActionPreference = 'Stop'
$DebugPreference = 'Continue'
$Connection = [SQLiteConnection]::new("Data Source=:memory:")

try {
    $Connection.Open()
    $Command = $Connection.CreateCommand()
    $Command.CommandText = [file]::ReadAllText($Global:conf.Queres.CreateTableWeekDay)
    $null = $Command.ExecuteNonQuery()
    $Command.Dispose()

    $Command = $Connection.CreateCommand()
    $Command.CommandText = [file]::ReadAllText($Global:conf.Queres.WeekDayInsert)
    $ParameterID = [SQLiteParameter]::new()
    $ParameterID.ParameterName = '@id'
    $ParameterName = [SQLiteParameter]::new()
    $ParameterName.ParameterName = '@name'
    $null = $Command.Parameters.Add($ParameterID)
    $null = $Command.Parameters.Add($ParameterName)
    [enum]::GetValues([System.DayOfWeek]).ForEach{
        $ParameterID.Value = [int]$_
        $ParameterName.Value = $_
        $null = $Command.ExecuteNonQuery()
    }
    $Command.Dispose()

    $Command = $Connection.CreateCommand()
    $Command.CommandText = [file]::ReadAllText($conf.Queres.SelectFromW)
    $DataTable = [DataTable]::new()
    $DataTable.Load($Command.ExecuteReader())
    $Command.Dispose()

    for ($i = 0; $i -lt $DataTable.Rows.Count; $i++) {
        if ($DataTable.Rows[$i]["id"] -in 0, 2,6) {
            $DataTable.Rows.RemoveAt($i)
            $i--
        }
    } 
    $DataTable
}
catch {
    throw $_
}
finally {
    $Connection.Close()    
}




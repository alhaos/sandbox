using namespace System.Data.Sqlite
using namespace System.Data
using namespace System.IO
using assembly C:\repositories\pwsh\sqlLite\lib\System.Data.SQLite.dll 

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
    
    $Command.Dispose()

    $DataTable = [DataTable]::new()

    $DataTable


}
catch {
    throw $_
}
finally {
    $Connection.Close()    
}




using namespace System.Data.Sqlite
using namespace System.Data
using namespace System.IO

using assembly .\lib\System.Data.SQLite.dll 

$Connection = $Connection = [SQLiteConnection]::new("Data Source=.\lib\database.db")

$Connection.Open()

$connamd = $Connection.CreateCommand()

$connamd.CommandText = 'insert into RECURRING_REQUESTS (ID, DT) values (@ID, @DT);'
$ParameterId = [SQLiteParameter]::new('@ID', [string])
$ParameterDt = [SQLiteParameter]::new('@DT', [datetime])
$null = $connamd.Parameters.Add($ParameterId)
$null = $connamd.Parameters.Add($ParameterDt)

$ParameterId.Value = '1'
$ParameterDt.Value = [datetime]::Today

try {
    $connamd.ExecuteNonQuery()    
}
catch [System.Management.Automation.MethodException] {
    $_.Exception.GetType()
}

$Connection.Close()



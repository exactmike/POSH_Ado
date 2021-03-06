ipmo firebirdlib -Force 

function AssertEquals{
param($lhs,$rhs,$description)
if ($lhs -eq $rhs){ 
	Write-Host "$description PASSED" -BackgroundColor Green 
} else {
	Write-Host "$description FAILED" -BackgroundColor Red
}
}

$server = 'localhost'
$db = 'c:\temp\testado.fdb'
$sql = 'SELECT * from Person'

#test simple query using ad hoc connection and NT authentication
$rows=invoke-FirebirdQuery -sql $sql -server $server -database $db -user test_login -password 12345
AssertEquals $rows.Count 5 "ad hoc connection with NT auth" 

##test simple query using ad hoc connection and SQL login
#$rows=invoke-FirebirdQuery -sql $sql -server $server -database $db -user test_login -password 12345
#AssertEquals $rows.Count 5 "ad hoc connection with SQL Login" 

##test parameterized query with ad hoc connection and sql login
#$rows=@(invoke-FirebirdQuery -sql 'select * from Person where LastName like @pattern' -server $server -database $db -user test_login -password 12345 -parameters @{pattern='M%'})
#AssertEquals $rows.Count 2 "parameterized query with sql login" 

#test parameterized query with ad hoc connection and nt authentication
$rows=@(invoke-FirebirdQuery -sql 'select * from Person where LastName like @pattern' -server $server -database $db -user test_login -password 12345 -parameters @{pattern='M%'})
AssertEquals $rows.Count 2 "parameterized query with NT Auth" 

Remove-Variable conn -ea SilentlyContinue
$conn=new-Firebirdconnection  -server $server -database $db -user test_login -password 12345

#test simple query using shared connection and NT authentication
$rows=invoke-FirebirdQuery -sql $sql -conn $conn 
AssertEquals $rows.Count 5 "shared connection with NT auth" 

#test parameterized query with shared connection and NT Auth
$rows=@(invoke-FirebirdQuery -sql 'select * from Person where LastName like @pattern' -conn $conn  -parameters @{pattern='M%'})
AssertEquals $rows.Count 2 "parameterized query with shared connection and NT Auth" 

#test stored procedure query with shared connection and NT Auth and IN parameters
$rows=@(invoke-Firebirdstoredprocedure  -storedProcName stp_TestInputParameter  -conn $conn  -parameters @{prmPersonID=2})
AssertEquals $rows.Count 1 "stored procedure (in) with shared connection and NT Auth" 

#test stored procedure query with shared connection and NT Auth and out parameters
$outRows=invoke-Firebirdstoredprocedure  -storedProcName stp_TestOutputParameter  -conn $conn  -parameters @{prmPersonID=3} -outparameters @{prmFullName='varchar(101)'} 
#AssertEquals ($outrows.results.prmFullName -eq 'Mike Shepard') $true "parameterized query (out) with shared connection and NT Auth" 
AssertEquals ($outrows.Results.rows[0].PRMFULLNAME -eq 'Mike Shepard') $true "parameterized query (out) with shared connection and NT Auth" 

#test NULL parameters
$rows=invoke-FirebirdQuery "SELECT * from Person where @parm is NULL" -conn $conn -parameters @{parm=[System.DBNull]::Value}
AssertEquals $rows.Count 5 "shared connection null parameters" 

#test simple query using ad hoc connection and SQL Login with "-AsResult DataTable"
$rows=invoke-FirebirdQuery -sql $sql -server $server -database $db -AsResult DataTable -user test_login -password 12345
AssertEquals ($rows -is [Data.DataTable]) $true  "ad hoc connection with SQL Login as DataTable" 

#test simple query using ad hoc connection and SQL Login with "-AsResult DataSet"
$rows=invoke-FirebirdQuery -sql $sql -server $server -database $db -AsResult DataSet -user test_login -password 12345
AssertEquals ($rows -is [Data.DataSet]) $true  "ad hoc connection with SQL Login as DataSet" 


#test simple query using ad hoc connection and SQL Login with "-AsResult DataRow"
$rows=@(invoke-FirebirdQuery -sql $sql -server $server -database $db -AsResult DataRow -user test_login -password 12345)
AssertEquals ($rows[0] -is [Data.DataRow]) $true  "ad hoc connection with SQL Login as DataRow" 

$conn.Close()

remove-variable conn

#$conn=new-sqlconnection  -server $server -database $db  -user test_login -password 12345


#test simple query using shared connection and SQL login
#$rows=invoke-FirebirdQuery -sql $sql -conn $conn 
#AssertEquals $rows.Count 5 "shared connection and SQL login" 

##test parameterized query with shared connection and sql login
#$rows=@(invoke-FirebirdQuery -sql 'select * from Person where LastName like @pattern' -conn $conn  -parameters @{pattern='M%'})
#AssertEquals $rows.Count 2 "parameterized query with shared connection and sql login" 
 


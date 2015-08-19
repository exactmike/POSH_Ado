# ---------------------------------------------------------------------------
### <Script>
### <Author>
### Mike Shepard
### </Author>
### <Description>
### Defines functions for executing Ado.net queries with the DB2 data provider. 
### </Description>
### <Usage>
### import-module OraLib
###  </Usage>
### </Script>
# ---------------------------------------------------------------------------


import-module adonetlib -args IBM.Data.DB2 -Prefix DB2 -force

Set-DB2ADONetParameters  -ServerToken 'Server' -UserToken 'UID' -PasswordToken 'PWD' -AllowNTAuthentication $false

Export-ModuleMember *-DB2*

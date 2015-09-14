# ---------------------------------------------------------------------------
### <Script>
### <Author>
### Mike Shepard
### </Author>
### <Description>
### Defines functions for executing Ado.net queries with the SQLServer (SQLClient) DataAccess data provider. 
### </Description>
### <Usage>
### import-module POSH_Ado_SQLServer
###  </Usage>
### </Script>
# ---------------------------------------------------------------------------

import-module adonetlib -args System.Data.SqlClient -Prefix SQLServer -force

Export-ModuleMember *-SQLServer*

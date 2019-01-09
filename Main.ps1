if (Get-Module SQLPerfTuning){
	Remove-Module SQLPerfTuning
}
Import-Module .\Modules\SQLPerfTuning.psm1

function DoSQLPerfTune(){
	Param([string]$InstanceName,[string]$dbname, [string]$QueryFile, [string]$MaxDOP, [string]$CostOfPar)

	##Fetching XML content and converting to array of queries
	[xml]$XMLQueries = get-xmlcontent -XMLFile $QueryFile
	[array]$ArrQueries = Convert-XMLContent -XMLContent $XMLQueries

	#Connecting to SQL
	$db = Connect-ToDatabase -instancename $InstanceName -dbname $dbname
	$db.collation      #For debugging
	
	<#
	foreach($item in $ArrQueries){
		$item
		$StartTime = Get-Date
		$db.ExecuteWithResults($item) 
		$EndTime = Get-Date
		$Duration = New-TimeSpan -Start $StartTime -End $EndTime
		Write-Host "Execution took: $duration"
	}
	###Issue with executing the query...
	#>

	<#
	foreach($query in $ArrQueries){
		$StartTime = Get-Date
		Write-Host $query
		$ds = $db.ExecuteWithResults($query) 
		$EndTime = Get-Date
		$Duration = New-TimeSpan -Start $StartTime -End $EndTime
		Write-Host "Execution took: $duration"
	}
	#>
}

DoSQLPerfTune -InstanceName 'localhost' -QueryFile ".\Examples\Queries.xml" -dbname "WideWorldImporters"
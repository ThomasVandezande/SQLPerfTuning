function Connect-ToDatabase {
	param ([string]$InstanceName,
	[string]$dbname)
	Write-Host -ForegroundColor Green "Connecting to SQL instance $InstanceName"
	try{
		# Load the SMO assembly 
		[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo"); 
		Write-Host "SMO imported"     #For debugging
	} catch{
		$ErrorMessage = $_.Exception.Message
		Write-Host -ForegroundColor Red "Failed to import the SQLServer SMO object with error $ErrorMessage"
	}

	try{
		$srv = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server $InstanceName
		Write-host "Server Connected"      #For debugging
		Write-Host $srv.GetType()
		$db =New-Object Microsoft.SqlServer.Management.Smo.Database  
		$db = $srv.databases.item($dbname)
		Write-Host "Connected to database $dbname"
		return $db
	} catch {
		$ErrorMessage = $_.Exception.Message
		Write-Host -ForegroundColor Red "Failed to connect to the SQL instance with error $ErrorMessage"
	}

}

function Get-XMLContent{
	param([string]$XMLFile)

	try{
		Write-Host -ForegroundColor Green "Getting queries from XML file ...."
		[xml]$XMLContent  = Get-Content $XMLFile
		return $XMLContent
	}catch{
		$ErrorMessage = $_.Exception.Message
		Write-Host -ForegroundColor Red "Getting XML File failed with the following error: $ErrorMessage"
	}
}

function Convert-XMLContent(){
	param([XML]$XMLContent)

	Write-Host -foregroundcolor green "Following queries will be tested:"

		$Queries = $xmlcontent.selectnodes("/queries/query") #case sensitive in XML file
	if ($Queries.Count -eq 0){
		Write-Host -ForegroundColor Red "Getting queries from XML failed, you are sure the right element structure was used?
		<queries>
			<query></query>
		</queries>
The element names are case sensitive.
		"
	}
	foreach($query in $queries){
		Write-Host $Query.get_InnerXml()
	}
	return $Queries
}


#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ServerInstance = 'BC250',

    [Parameter(Mandatory = $false)]
    [string]$CompanyName = 'SCANPAN Danmark'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Import-BusinessCentralAdminTool {
    [CmdletBinding()]
    param()

    if ($null -ne (Get-Command -Name Get-NAVServerConfiguration -ErrorAction SilentlyContinue)) {
        return
    }

    [string]$businessCentralRoot = Join-Path -Path $env:ProgramFiles -ChildPath 'Microsoft Dynamics 365 Business Central'

    if (-not (Test-Path -LiteralPath $businessCentralRoot)) {
        throw "Business Central installation folder was not found at '$businessCentralRoot'. Run this script on the Business Central application server."
    }

    [System.IO.FileInfo[]]$adminTools = @(
        Get-ChildItem -LiteralPath $businessCentralRoot -Recurse -Filter 'NavAdminTool.ps1' -File |
            Sort-Object -Property LastWriteTimeUtc, FullName -Descending
    )

    if ($adminTools.Count -eq 0) {
        throw "NavAdminTool.ps1 was not found below '$businessCentralRoot'. The Business Central administration tool must be installed on this server."
    }

    [string]$adminToolPath = $adminTools[0].FullName
    [object[]]$adminToolOutput = @(. $adminToolPath)
    $null = $adminToolOutput

    if ($null -eq (Get-Command -Name Get-NAVServerConfiguration -ErrorAction SilentlyContinue)) {
        throw "Get-NAVServerConfiguration was not available after loading '$adminToolPath'. Verify that the Business Central administration tool is installed correctly."
    }
}

function Get-ConfigurationValue {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$ConfigurationRows,

        [Parameter(Mandatory = $true)]
        [string]$KeyName
    )

    [string[]]$keyPropertyNames = @('KeyName', 'key')
    [string[]]$valuePropertyNames = @('KeyValue', 'Value', 'value')

    [object[]]$matchingRows = @(
        $ConfigurationRows |
            Where-Object {
                foreach ($keyPropertyName in $keyPropertyNames) {
                    if ($_.PSObject.Properties.Name -contains $keyPropertyName) {
                        if ([string]$_.PSObject.Properties[$keyPropertyName].Value -eq $KeyName) {
                            return $true
                        }
                    }
                }
                return $false
            }
    )

    if ($matchingRows.Count -ne 1) {
        throw "Expected exactly one configuration row for '$KeyName', but found $($matchingRows.Count)."
    }

    foreach ($valuePropertyName in $valuePropertyNames) {
        if ($matchingRows[0].PSObject.Properties.Name -contains $valuePropertyName) {
            return [string]$matchingRows[0].PSObject.Properties[$valuePropertyName].Value
        }
    }

    throw "Configuration row for '$KeyName' does not expose a supported value property."
}

function Invoke-SqlQuery {
    [CmdletBinding()]
    [OutputType([System.Data.DataTable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConnectionString,

        [Parameter(Mandatory = $true)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [hashtable]$Parameters = @{}
    )

    [System.Data.SqlClient.SqlConnection]$connection = [System.Data.SqlClient.SqlConnection]::new($ConnectionString)
    [System.Data.SqlClient.SqlCommand]$command = $connection.CreateCommand()
    $command.CommandText = $Query
    $command.CommandTimeout = 120

    foreach ($parameterName in $Parameters.Keys) {
        [System.Data.SqlClient.SqlParameter]$parameter = $command.Parameters.AddWithValue($parameterName, $Parameters[$parameterName])
        $null = $parameter
    }

    [System.Data.DataTable]$dataTable = [System.Data.DataTable]::new()

    try {
        $connection.Open()
        [System.Data.SqlClient.SqlDataAdapter]$adapter = [System.Data.SqlClient.SqlDataAdapter]::new($command)
        $null = $adapter.Fill($dataTable)
    } finally {
        $connection.Dispose()
    }

    return $dataTable
}

function Quote-SqlName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    return '[' + $Name.Replace(']', ']]') + ']'
}

Import-BusinessCentralAdminTool

[object[]]$configurationRows = @(Get-NAVServerConfiguration -ServerInstance $ServerInstance)
[string]$databaseServer = Get-ConfigurationValue -ConfigurationRows $configurationRows -KeyName 'DatabaseServer'
[string]$databaseInstance = Get-ConfigurationValue -ConfigurationRows $configurationRows -KeyName 'DatabaseInstance'
[string]$databaseName = Get-ConfigurationValue -ConfigurationRows $configurationRows -KeyName 'DatabaseName'

[string]$dataSource = $databaseServer
if (-not [string]::IsNullOrWhiteSpace($databaseInstance)) {
    $dataSource = "$databaseServer\$databaseInstance"
}

[string]$connectionString = "Data Source=$dataSource;Initial Catalog=$databaseName;Integrated Security=SSPI;TrustServerCertificate=True"

[System.Data.DataTable]$tables = Invoke-SqlQuery -ConnectionString $connectionString -Query @'
select
    schema_name(t.schema_id) as SchemaName,
    t.name as TableName
from sys.tables as t
where
    t.name like @PackageSetupTable
    or t.name like @PackageTypeTable
order by t.name;
'@ -Parameters @{
    '@PackageSetupTable' = "$CompanyName`$MOB Mobile WMS Package Setup%"
    '@PackageTypeTable' = "$CompanyName`$MOB Package Type%"
}

[object[]]$packageSetupTables = @($tables | Where-Object { [string]$_.'TableName' -like "$CompanyName`$MOB Mobile WMS Package Setup*" })
[object[]]$packageTypeTables = @($tables | Where-Object { [string]$_.'TableName' -like "$CompanyName`$MOB Package Type*" })

if ($packageSetupTables.Count -ne 1) {
    throw "Expected exactly one SQL table for '$CompanyName`$MOB Mobile WMS Package Setup', but found $($packageSetupTables.Count)."
}

if ($packageTypeTables.Count -ne 1) {
    throw "Expected exactly one SQL table for '$CompanyName`$MOB Package Type', but found $($packageTypeTables.Count)."
}

[string]$packageSetupTableName = (Quote-SqlName -Name ([string]$packageSetupTables[0].SchemaName)) + '.' + (Quote-SqlName -Name ([string]$packageSetupTables[0].TableName))
[string]$packageTypeTableName = (Quote-SqlName -Name ([string]$packageTypeTables[0].SchemaName)) + '.' + (Quote-SqlName -Name ([string]$packageTypeTables[0].TableName))

Write-Host ''
Write-Host "Database: $dataSource / $databaseName"
Write-Host "Package setup table: $packageSetupTableName"
Write-Host "Package type table:  $packageTypeTableName"

[string]$setupDuplicateQuery = @"
with SetupRows as (
    select
        s.[Shipping Agent],
        s.[Shipping Agent Service Code],
        s.[Package Type],
        p.[Shipping Provider Id],
        p.[Shipping Provider Package Type],
        coalesce(nullif(p.[Description], ''), s.[Package Type]) as DisplayText
    from $packageSetupTableName as s
    left join $packageTypeTableName as p
        on p.[Code] = s.[Package Type]
),
DuplicateRows as (
    select
        [Shipping Agent],
        [Shipping Agent Service Code],
        DisplayText,
        count(*) as DuplicateCount
    from SetupRows
    group by [Shipping Agent], [Shipping Agent Service Code], DisplayText
    having count(*) > 1
)
select
    d.DuplicateCount,
    r.[Shipping Agent],
    r.[Shipping Agent Service Code],
    r.DisplayText,
    r.[Package Type],
    r.[Shipping Provider Id],
    r.[Shipping Provider Package Type]
from SetupRows as r
inner join DuplicateRows as d
    on d.[Shipping Agent] = r.[Shipping Agent]
    and d.[Shipping Agent Service Code] = r.[Shipping Agent Service Code]
    and d.DisplayText = r.DisplayText
order by
    r.[Shipping Agent],
    r.[Shipping Agent Service Code],
    r.DisplayText,
    r.[Package Type];
"@

[string]$packageTypeDuplicateQuery = @"
with PackageRows as (
    select
        [Code],
        [Shipping Provider Id],
        [Shipping Provider Package Type],
        coalesce(nullif([Description], ''), [Code]) as DisplayText
    from $packageTypeTableName
),
DuplicateRows as (
    select
        [Shipping Provider Id],
        [Shipping Provider Package Type],
        DisplayText,
        count(*) as DuplicateCount
    from PackageRows
    group by [Shipping Provider Id], [Shipping Provider Package Type], DisplayText
    having count(*) > 1
)
select
    d.DuplicateCount,
    r.[Shipping Provider Id],
    r.[Shipping Provider Package Type],
    r.DisplayText,
    r.[Code]
from PackageRows as r
inner join DuplicateRows as d
    on d.[Shipping Provider Id] = r.[Shipping Provider Id]
    and d.[Shipping Provider Package Type] = r.[Shipping Provider Package Type]
    and d.DisplayText = r.DisplayText
order by
    r.[Shipping Provider Id],
    r.[Shipping Provider Package Type],
    r.DisplayText,
    r.[Code];
"@

[string]$setupOverviewQuery = @"
select
    [Shipping Agent],
    [Shipping Agent Service Code],
    count(*) as SetupLineCount
from $packageSetupTableName
group by [Shipping Agent], [Shipping Agent Service Code]
order by [Shipping Agent], [Shipping Agent Service Code];
"@

Write-Host ''
Write-Host 'Duplicate display texts inside Mobile WMS Package Setup per shipping agent/service'
[System.Data.DataTable]$setupDuplicates = Invoke-SqlQuery -ConnectionString $connectionString -Query $setupDuplicateQuery
if ($setupDuplicates.Rows.Count -eq 0) {
    Write-Host 'No duplicate setup display texts found.'
} else {
    $setupDuplicates | Format-Table -AutoSize -Wrap
}

Write-Host ''
Write-Host 'Duplicate package types by shipping provider/package/display text'
[System.Data.DataTable]$packageTypeDuplicates = Invoke-SqlQuery -ConnectionString $connectionString -Query $packageTypeDuplicateQuery
if ($packageTypeDuplicates.Rows.Count -eq 0) {
    Write-Host 'No duplicate package type display texts found.'
} else {
    $packageTypeDuplicates | Format-Table -AutoSize -Wrap
}

Write-Host ''
Write-Host 'Mobile WMS Package Setup line counts per shipping agent/service'
Invoke-SqlQuery -ConnectionString $connectionString -Query $setupOverviewQuery |
    Format-Table -AutoSize -Wrap

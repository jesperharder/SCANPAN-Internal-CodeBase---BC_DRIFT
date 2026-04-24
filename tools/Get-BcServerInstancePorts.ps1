#Requires -Version 5.1

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

function Get-BusinessCentralServerServices {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    [object[]]$services = @(
        Get-Service |
            Where-Object { $_.Name -like 'MicrosoftDynamicsNavServer$*' } |
            Sort-Object -Property Name
    )

    if ($services.Count -eq 0) {
        throw 'No Business Central server services were found. Expected Windows services named MicrosoftDynamicsNavServer$<InstanceName>.'
    }

    return $services
}

function Get-ConfigurationText {
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
                [string[]]$propertyNames = @($_.PSObject.Properties.Name)
                [string[]]$availableKeyPropertyNames = @($keyPropertyNames | Where-Object { $propertyNames -contains $_ })

                if ($availableKeyPropertyNames.Count -eq 0) {
                    throw "Configuration row does not expose a supported key property while looking for '$KeyName'. Expected one of: $($keyPropertyNames -join ', '). Actual properties: $($propertyNames -join ', ')."
                }

                [string]$_.PSObject.Properties[$availableKeyPropertyNames[0]].Value -eq $KeyName
            }
    )

    if ($matchingRows.Count -ne 1) {
        throw "Expected exactly one configuration row for '$KeyName', but found $($matchingRows.Count)."
    }

    [object]$matchingRow = $matchingRows[0]
    [string[]]$matchingPropertyNames = @($matchingRow.PSObject.Properties.Name)
    [string[]]$availableValuePropertyNames = @($valuePropertyNames | Where-Object { $matchingPropertyNames -contains $_ })

    if ($availableValuePropertyNames.Count -gt 0) {
        return [string]$matchingRow.PSObject.Properties[$availableValuePropertyNames[0]].Value
    }

    throw "Configuration row for '$KeyName' does not expose a supported value property. Expected one of: $($valuePropertyNames -join ', '). Actual properties: $($matchingPropertyNames -join ', ')."
}

function Get-PublicWebPortText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$PublicWebBaseUrl
    )

    if ([string]::IsNullOrWhiteSpace($PublicWebBaseUrl)) {
        return ''
    }

    [System.Uri]$publicWebUri = [System.Uri]::new($PublicWebBaseUrl)

    return [string]$publicWebUri.Port
}

function New-InstancePortRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Service
    )

    [string]$serviceNamePrefix = 'MicrosoftDynamicsNavServer$'
    [string]$serverInstance = $Service.Name.Substring($serviceNamePrefix.Length)
    [object[]]$configurationRows = @(Get-NAVServerConfiguration -ServerInstance $serverInstance)

    if ($configurationRows.Count -eq 0) {
        throw "No Business Central configuration rows were returned for server instance '$serverInstance'."
    }

    [string]$publicWebBaseUrl = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'PublicWebBaseUrl'

    return [pscustomobject]@{
        Instance         = $serverInstance
        Status           = [string]$Service.Status
        CredentialType   = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'ClientServicesCredentialType'
        Developer        = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'DeveloperServicesPort'
        Client           = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'ClientServicesPort'
        SOAP             = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'SOAPServicesPort'
        OData            = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'ODataServicesPort'
        Management       = Get-ConfigurationText -ConfigurationRows $configurationRows -KeyName 'ManagementServicesPort'
        WebClient        = Get-PublicWebPortText -PublicWebBaseUrl $publicWebBaseUrl
        PublicWebBaseUrl = $publicWebBaseUrl
    }
}

function Get-UniquePortRows {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject[]]$InstanceRows
    )

    [string[]]$portPropertyNames = @(
        'Developer',
        'Client',
        'SOAP',
        'OData',
        'Management',
        'WebClient'
    )

    [pscustomobject[]]$portRows = @(
        foreach ($instanceRow in $InstanceRows) {
            foreach ($portPropertyName in $portPropertyNames) {
                [string]$portText = [string]$instanceRow.PSObject.Properties[$portPropertyName].Value

                if (-not [string]::IsNullOrWhiteSpace($portText)) {
                    [pscustomobject]@{
                        Port = [int]$portText
                    }
                }
            }
        }
    )

    return @(
        $portRows |
            Sort-Object -Property Port -Unique
    )
}

Import-BusinessCentralAdminTool

[object[]]$services = @(Get-BusinessCentralServerServices)
[pscustomobject[]]$rows = @(
    $services |
        ForEach-Object {
            New-InstancePortRow -Service $_
        }
)

Write-Host ''
Write-Host 'Business Central instances and ports'

$rows |
    Format-Table -Property Instance, Status, CredentialType, Developer, Client, SOAP, OData, Management, WebClient, PublicWebBaseUrl -AutoSize -Wrap

[pscustomobject[]]$uniquePortRows = @(Get-UniquePortRows -InstanceRows $rows)

Write-Host ''
Write-Host 'Isolated unique port IDs'

$uniquePortRows |
    Format-Table -Property Port -AutoSize

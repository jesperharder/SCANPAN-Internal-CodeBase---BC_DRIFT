#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ServerInstance = 'BC250',

    [Parameter(Mandatory = $false)]
    [string]$Tenant = 'default',

    [Parameter(Mandatory = $false)]
    [string]$AppJsonPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($AppJsonPath)) {
    [string]$scriptDirectory = Split-Path -Parent $PSCommandPath
    [string]$projectDirectory = Split-Path -Parent $scriptDirectory
    $AppJsonPath = Join-Path -Path $projectDirectory -ChildPath 'app.json'
}

function Import-BusinessCentralAdminTool {
    [CmdletBinding()]
    param()

    if ($null -ne (Get-Command -Name Get-NAVAppInfo -ErrorAction SilentlyContinue)) {
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

    if ($null -eq (Get-Command -Name Get-NAVAppInfo -ErrorAction SilentlyContinue)) {
        throw "Get-NAVAppInfo was not available after loading '$adminToolPath'. Verify that the Business Central administration tool is installed correctly."
    }
}

function Read-ProjectDependencies {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "app.json was not found at '$Path'."
    }

    [object]$appJson = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json

    return @(
        $appJson.dependencies |
            ForEach-Object {
                [pscustomobject]@{
                    Id        = [string]$_.id
                    Publisher = [string]$_.publisher
                    Name      = [string]$_.name
                    Version   = [version]$_.version
                }
            }
    )
}

function Get-AppVersionText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [object]$AppInfo
    )

    [string[]]$versionPropertyNames = @('Version', 'PackageVersion')

    foreach ($versionPropertyName in $versionPropertyNames) {
        if ($AppInfo.PSObject.Properties.Name -contains $versionPropertyName) {
            [object]$versionValue = $AppInfo.PSObject.Properties[$versionPropertyName].Value
            if ($null -ne $versionValue -and -not [string]::IsNullOrWhiteSpace([string]$versionValue)) {
                return [string]$versionValue
            }
        }
    }

    return ''
}

function Get-AppIdText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [object]$AppInfo
    )

    [string[]]$idPropertyNames = @('AppId', 'Id')

    foreach ($idPropertyName in $idPropertyNames) {
        if ($AppInfo.PSObject.Properties.Name -contains $idPropertyName) {
            [object]$idValue = $AppInfo.PSObject.Properties[$idPropertyName].Value
            if ($null -ne $idValue -and -not [string]::IsNullOrWhiteSpace([string]$idValue)) {
                return [string]$idValue
            }
        }
    }

    return ''
}

function Find-MatchingApp {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Dependency,

        [Parameter(Mandatory = $true)]
        [object[]]$AppInfos
    )

    [object[]]$idMatches = @(
        $AppInfos |
            Where-Object { (Get-AppIdText -AppInfo $_) -eq $Dependency.Id }
    )

    if ($idMatches.Count -gt 0) {
        return @($idMatches | Sort-Object -Property Version -Descending)[0]
    }

    [object[]]$nameMatches = @(
        $AppInfos |
            Where-Object {
                [string]$_.Publisher -eq $Dependency.Publisher -and
                [string]$_.Name -eq $Dependency.Name
            }
    )

    if ($nameMatches.Count -gt 0) {
        return @($nameMatches | Sort-Object -Property Version -Descending)[0]
    }

    return $null
}

function New-AppComparisonRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Dependency,

        [Parameter(Mandatory = $true)]
        [object[]]$PublishedApps,

        [Parameter(Mandatory = $true)]
        [object[]]$InstalledApps
    )

    [object]$publishedApp = Find-MatchingApp -Dependency $Dependency -AppInfos $PublishedApps
    [object]$installedApp = Find-MatchingApp -Dependency $Dependency -AppInfos $InstalledApps

    [string]$publishedVersionText = if ($null -eq $publishedApp) { '' } else { Get-AppVersionText -AppInfo $publishedApp }
    [string]$installedVersionText = if ($null -eq $installedApp) { '' } else { Get-AppVersionText -AppInfo $installedApp }

    [version]$publishedVersion = $null
    [version]$installedVersion = $null

    if (-not [string]::IsNullOrWhiteSpace($publishedVersionText)) {
        $publishedVersion = [version]$publishedVersionText
    }

    if (-not [string]::IsNullOrWhiteSpace($installedVersionText)) {
        $installedVersion = [version]$installedVersionText
    }

    [string]$status = 'OK'

    if ($null -eq $publishedApp) {
        $status = 'Missing published'
    } elseif ($null -ne $publishedVersion -and $publishedVersion -lt $Dependency.Version) {
        $status = 'Published older than app.json'
    }

    if ($null -eq $installedApp) {
        $status = 'Missing installed'
    } elseif ($null -ne $installedVersion -and $installedVersion -lt $Dependency.Version) {
        $status = 'Installed older than app.json'
    }

    return [pscustomobject]@{
        Status            = $status
        Publisher         = $Dependency.Publisher
        Name              = $Dependency.Name
        RequiredVersion   = [string]$Dependency.Version
        PublishedVersion  = $publishedVersionText
        InstalledVersion  = $installedVersionText
        PublishedAppName  = if ($null -eq $publishedApp) { '' } else { [string]$publishedApp.Name }
        InstalledAppName  = if ($null -eq $installedApp) { '' } else { [string]$installedApp.Name }
    }
}

Import-BusinessCentralAdminTool

[pscustomobject[]]$dependencies = @(Read-ProjectDependencies -Path $AppJsonPath)
[object[]]$publishedApps = @(Get-NAVAppInfo -ServerInstance $ServerInstance)
[object[]]$installedApps = @(Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant)

[pscustomobject[]]$rows = @(
    $dependencies |
        ForEach-Object {
            New-AppComparisonRow -Dependency $_ -PublishedApps $publishedApps -InstalledApps $installedApps
        }
)

$rows |
    Sort-Object -Property Publisher, Name |
    Format-Table -AutoSize -Wrap

[pscustomobject[]]$problemRows = @($rows | Where-Object { $_.Status -ne 'OK' })

if ($problemRows.Count -gt 0) {
    throw "Found $($problemRows.Count) app dependency version issue(s) for server instance '$ServerInstance' and tenant '$Tenant'."
}

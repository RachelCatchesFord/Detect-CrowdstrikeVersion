$appToMatch = '*CrowdStrike Windows*'
$VerToMatch = "5.30.11206.0"
$CheckAgentStatus = & cmd /c "sc query csagent"
$AgentHealth = $CheckAgentStatus | Select-String -Pattern "STATE"
$AgentIsRunning = "*STATE              : 4  RUNNING*"
    
function Get-InstalledApps{
    if ([IntPtr]::Size -eq 4) {
                $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    }
    else {
                $regpath = @(
                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                    'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
               )
      }
Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |Sort DisplayName
}

$result = Get-InstalledApps | where {$_.DisplayName -like $appToMatch}
Write-Output $result.DisplayVersion
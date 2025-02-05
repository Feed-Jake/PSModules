# Get-DefenderStatus.psm1

function Get-DefenderStatus {
    $services = Get-Service -Name 'WinDefend', 'WdNisSvc'
    foreach ($service in $services) {
        Write-Output "$($service.Name) is $($service.Status)"
    }
}

function Update-DefenderSignatures {
    Write-Output "Updating Windows Defender signatures..."
    Update-MpSignature
    Write-Output "Update complete."
}

function Start-DefenderQuickScan {
    Write-Output "Starting quick scan..."
    Start-MpScan -ScanType QuickScan
    Write-Output "Quick scan complete."
}

Export-ModuleMember -Function Get-DefenderStatus, Update-DefenderSignatures, Start-DefenderQuickScan
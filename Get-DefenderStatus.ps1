# Get-DefenderStatus.psm1

function Get-DefenderStatus {
    $services = Get-Service *Defend*
    foreach ($service in $services) {
        Write-Output "$($service.Name) is $($service.Status)"
    }
}

function Update-DefenderSignatures {
    Write-Output "Updating Windows Defender signatures..."
    Update-MpSignature -Verbose
    Write-Output "Update complete."
}

function Start-DefenderQuickScan {
    Write-Host "Starting quick scan..."
    Start-MpScan -ScanType QuickScan -Verbose
    Write-Output "Quick scan complete."
}

Export-ModuleMember -Function Get-DefenderStatus, Update-DefenderSignatures, Start-DefenderQuickScan
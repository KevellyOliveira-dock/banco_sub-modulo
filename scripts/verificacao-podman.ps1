Write-Output ""
Write-Output "=== Verificando instalacao do Python ==="

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version
    Write-Output "Python encontrado: $pythonVersion"
} else {
    Write-Output "Python NAO encontrado"
}

Write-Output ""
Write-Output "=== Verificando instalacao do pip ==="

if (Get-Command pip -ErrorAction SilentlyContinue) {
    $pipVersion = pip --version
    Write-Output "pip encontrado: $pipVersion"
} else {
    Write-Output "pip NAO encontrado"
}

Write-Output ""
Write-Output "=== Verificando instalacao do Podman CLI ==="

if (Get-Command podman -ErrorAction SilentlyContinue) {
    $podmanVersion = podman --version
    Write-Output "Podman encontrado: $podmanVersion"
} else {
    Write-Output "Podman NAO encontrado"
}
Write-Output ""
Write-Output "=== Verificando instalacao do podman-compose ==="

if (Get-Command podman-compose -ErrorAction SilentlyContinue) {
    $composeVersion = podman-compose --version | Select-String -Pattern 'podman-compose version' | ForEach-Object { $_.Line }
    Write-Output "podman-compose encontrado: $composeVersion"
} else {
    Write-Output "podman-compose NAO encontrado"
}

Write-Output ""
Write-Output "=== Verificacao finalizada ==="
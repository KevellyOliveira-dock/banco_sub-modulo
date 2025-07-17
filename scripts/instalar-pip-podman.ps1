# Baixando o instalador do pip
Write-Output "=== Baixando o instalador do pip ==="
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$env:USERPROFILE\Downloads\get-pip.py"

Write-Output "=== Instalador baixado ==="
Write-Output "Agora vamos executar o instalador do pip"

# Acessa a pasta Downloads
Set-Location "$env:USERPROFILE\Downloads"

# Executa o instalador do pip
python get-pip.py

# Verifica se o pip foi instalado
if (Get-Command pip -ErrorAction SilentlyContinue) {
    Write-Output "pip instalado com sucesso"
} else {
    Write-Output "Houve um problema na instalação do pip"
    exit 1
}

Write-Output "=== Instalando o podman-compose ==="
pip install podman-compose

# Verifica a instalação
if (Get-Command podman-compose -ErrorAction SilentlyContinue) {
    Write-Output "podman-compose instalado com sucesso"
    podman-compose --version
} else {
    Write-Output "Houve um problema na instalação do podman-compose"
    exit 1
}

Write-Output "=== Processo finalizado ==="

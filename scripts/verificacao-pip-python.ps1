Write-Output "=== Verificando instalacao do Python ==="

# Verifica se o python está instalado
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version
    Write-Output "Python instalado: $pythonVersion"
} else {
    Write-Output "Python NAO está instalado. Por favor, instale o Python antes de prosseguir."
    exit 1
}

Write-Output "=== Verificando instalacao do pip ==="

# Verifica se o pip está instalado
if (Get-Command pip -ErrorAction SilentlyContinue) {
    $pipVersion = pip --version
    Write-Output "pip instalado: $pipVersion"
} else {
    Write-Output "pip NAO esta instalado. Voce pode instala-lo baixando o get-pip.py e executando: python get-pip.py"
    exit 1
}

Write-Output "=== Todas as verificacoes concluidas com sucesso ==="
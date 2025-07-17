Write-Output "                                            "
Write-Output "=== Verificando instalacao do Python ==="

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version
    Write-Output "Python ja instalado: $pythonVersion"
} else {
    Write-Output "Python NAO esta instalado. Por favor, instale o Python 3 manualmente e rode novamente o script."
    exit 1
}

Write-Output "                                            "
Write-Output "=== Verificando instalacao do pip ==="

if (Get-Command pip -ErrorAction SilentlyContinue) {
    $pipVersion = pip --version
    Write-Output "pip ja instalado: $pipVersion"
} else {
    Write-Output "pip NAO esta instalado, instalando agora..."
    Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py
    python get-pip.py
    Remove-Item get-pip.py
    if (Get-Command pip -ErrorAction SilentlyContinue) {
        Write-Output "pip instalado com sucesso: $(pip --version)"
    } else {
        Write-Output "Falha ao instalar o pip, verifique o ambiente manualmente."
        exit 1
    }
}

Write-Output "                                            "
Write-Output "=== Verificando instalacao do Podman ==="

if (Get-Command podman -ErrorAction SilentlyContinue) {
    $podmanVersion = podman --version
    Write-Output "Podman ja instalado: $podmanVersion"
} else {
    Write-Output "Podman NAO esta instalado. Por favor, instale o Podman manualmente (https://podman.io/getting-started/installation) e rode novamente o script."
    exit 1
}

Write-Output "                                            "
Write-Output "=== Verificando instalacao do podman-compose ==="

if (Get-Command podman-compose -ErrorAction SilentlyContinue) {
    $podmanComposeVersion = podman-compose --version
    Write-Output "podman-compose ja instalado: $podmanComposeVersion"
} else {
    Write-Output "podman-compose NAO esta instalado, instalando agora via pip..."
    pip install podman-compose
    if (Get-Command podman-compose -ErrorAction SilentlyContinue) {
        $podmanComposeVersion = podman-compose --version
        Write-Output "podman-compose instalado com sucesso: $podmanComposeVersion"
    } else {
        Write-Output "Falha ao instalar podman-compose, verifique manualmente."
        exit 1
    }
}

Write-Output "                                            "
Write-Output "=== Tudo verificado e pronto para uso ==="

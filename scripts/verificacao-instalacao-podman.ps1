Write-Output ""
Write-Output "=== Verificando instalacao do Python ==="

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version
    Write-Output "Python ja esta instalado: $pythonVersion"
} else {
    Write-Output "Python NAO esta instalado. Baixando instalador oficial..."

    $pythonInstallerUrl = "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
    $installerPath = "$env:TEMP\python-installer.exe"

    Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $installerPath

    Write-Output "Instalador baixado. Instalando Python 3.12.3 em modo silencioso..."

    Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

    Remove-Item $installerPath

    if (Get-Command python -ErrorAction SilentlyContinue) {
        $pythonVersion = python --version
        Write-Output "Python instalado com sucesso: $pythonVersion"
    } else {
        Write-Output "Erro: Python nao foi instalado corretamente."
        exit 1
    }
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

Write-Output ""
Write-Output "=== Verificando instalacao do Podman CLI (linha de comando) ==="

if (Get-Command podman -ErrorAction SilentlyContinue) {
    $podmanVersion = podman --version
    Write-Output "Podman ja esta instalado: $podmanVersion"
} else {
    Write-Output "Podman NAO esta instalado. Baixando instalador oficial..."

    $podmanInstallerUrl = "https://github.com/containers/podman/releases/download/v5.0.3/podman-5.0.3-setup.exe"
    $installerPath = "$env:TEMP\podman-installer.exe"

    # Baixa o instalador direto do GitHub oficial
    Invoke-WebRequest -Uri $podmanInstallerUrl -OutFile $installerPath

    Write-Output "Instalador baixado. Instalando Podman CLI em modo silencioso..."

    Start-Process -FilePath $installerPath -ArgumentList "/SILENT" -Wait

    Remove-Item $installerPath

    # Verifica após instalar
    if (Get-Command podman -ErrorAction SilentlyContinue) {
        $podmanVersion = podman --version
        Write-Output "Podman instalado com sucesso: $podmanVersion"
    } else {
        Write-Output "Erro: Podman nao foi instalado corretamente. Verifique manualmente."
        exit 1
    }
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
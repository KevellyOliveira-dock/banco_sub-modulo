#!/bin/bash

echo ""
echo "=== Verificando instalacao do Python ==="

if command -v python3 &> /dev/null; then
    pythonVersion=$(python3 --version)
    echo "Python ja esta instalado: $pythonVersion"
else
    echo "Python NAO esta instalado. Instalando Python..."

    if [ -x "$(command -v apt)" ]; then
        sudo apt update
        sudo apt install -y python3 python3-venv python3-pip
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y python3 python3-pip
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y python3 python3-pip
    else
        echo "Gerenciador de pacotes nao suportado. Instale manualmente: https://www.python.org/downloads/"
        exit 1
    fi

    if command -v python3 &> /dev/null; then
        pythonVersion=$(python3 --version)
        echo "Python instalado com sucesso: $pythonVersion"
    else
        echo "Python nao foi instalado corretamente."
        exit 1
    fi
fi

echo ""
echo "=== Verificando instalacao do pip ==="

if command -v pip3 &> /dev/null; then
    pipVersion=$(pip3 --version)
    echo "pip ja instalado: $pipVersion"
else
    echo "pip NAO instalado, instalando agora..."
    curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm -f get-pip.py
    if command -v pip3 &> /dev/null; then
        echo "pip instalado com sucesso: $(pip3 --version)"
    else
        echo "Falha ao instalar pip, verifique manualmente."
        exit 1
    fi
fi

echo ""
echo "=== Verificando instalacao do Podman CLI ==="

if command -v podman &> /dev/null; then
    podmanVersion=$(podman --version)
    echo "Podman ja esta instalado: $podmanVersion"
else
    echo "Podman NAO instalado. Instalando via repositorio oficial..."

    if [ -x "$(command -v apt)" ]; then
        . /etc/os-release
        sudo sh -c "echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$ID/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
        curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$ID/Release.key" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/libcontainers-archive-keyring.gpg
        sudo apt update
        sudo apt install -y podman
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y install podman
    elif [ -x "$(command -v yum)" ]; then
        sudo yum -y install podman
    else
        echo "Gerenciador de pacotes nao suportado. Instale manualmente: https://podman.io/getting-started/installation"
        exit 1
    fi

    if command -v podman &> /dev/null; then
        podmanVersion=$(podman --version)
        echo "Podman instalado com sucesso: $podmanVersion"
    else
        echo "Podman nao foi instalado corretamente."
        exit 1
    fi
fi

echo ""
echo "=== Verificando instalacao do podman-compose ==="

if command -v podman-compose &> /dev/null; then
    composeVersion=$(podman-compose --version)
    echo "podman-compose ja instalado: $composeVersion"
else
    echo "podman-compose NAO instalado, instalando via pip..."
    pip3 install --user podman-compose
    if command -v podman-compose &> /dev/null; then
        echo "podman-compose instalado com sucesso: $(podman-compose --version)"
    else
        echo "podman-compose nao encontrado no PATH, adicionando manualmente..."
        export PATH=$PATH:~/.local/bin
        if command -v podman-compose &> /dev/null; then
            echo "podman-compose instalado com sucesso: $(podman-compose --version)"
        else
            echo "Falha ao instalar podman-compose, verifique manualmente."
            exit 1
        fi
    fi
fi

echo ""
echo "=== Tudo verificado e pronto para uso ==="

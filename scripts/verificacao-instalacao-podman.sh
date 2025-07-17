#!/bin/bash

echo "                                            "
echo "=== Verificando instalação do Python ==="

if command -v python3 &> /dev/null; then
    pythonVersion=$(python3 --version 2>&1)
    echo "Python já instalado: $pythonVersion"
else
    echo "Python NÃO está instalado. Por favor, instale o Python 3 manualmente e rode novamente o script."
    exit 1
fi

echo "                                            "
echo "=== Verificando instalação do pip ==="

if command -v pip3 &> /dev/null; then
    pipVersion=$(pip3 --version 2>&1)
    echo "pip já instalado: $pipVersion"
else
    echo "pip NÃO está instalado, instalando agora..."
    curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py && rm get-pip.py
    if command -v pip3 &> /dev/null; then
        echo "pip instalado com sucesso: $(pip3 --version)"
    else
        echo "Falha ao instalar o pip, verifique o ambiente manualmente."
        exit 1
    fi
fi

echo "                                            "
echo "=== Verificando instalação do podman ==="

if command -v podman &> /dev/null; then
    podmanVersion=$(podman --version 2>&1)
    echo "Podman já instalado: $podmanVersion"
else
    echo "Podman NÃO está instalado. Por favor, instale o Podman manualmente (exemplo para Debian/Ubuntu: sudo apt install podman) e rode novamente o script."
    exit 1
fi

echo "                                            "
echo "=== Verificando instalação do podman-compose ==="

if command -v podman-compose &> /dev/null; then
    podmanComposeVersion=$(podman-compose --version | grep "podman-compose version")
    echo "podman-compose já instalado: $podmanComposeVersion"
else
    echo "podman-compose NÃO está instalado, instalando agora via pip..."
    pip3 install podman-compose
    if command -v podman-compose &> /dev/null; then
        echo "podman-compose instalado com sucesso: $(podman-compose --version)"
    else
        echo "Falha ao instalar podman-compose, verifique manualmente."
        exit 1
    fi
fi

echo "                                            "
echo "=== Tudo verificado e pronto para uso ==="

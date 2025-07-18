#!/bin/bash

echo ""
echo "=== Verificando instalacao do Python ==="

if command -v python3 &> /dev/null; then
    pythonVersion=$(python3 --version)
    echo "Python encontrado: $pythonVersion"
else
    echo "Python NAO encontrado"
fi

echo ""
echo "=== Verificando instalacao do pip ==="

if command -v pip3 &> /dev/null; then
    pipVersion=$(pip3 --version)
    echo "pip encontrado: $pipVersion"
else
    echo "pip NAO encontrado"
fi

echo ""
echo "=== Verificando instalacao do Podman CLI ==="

if command -v podman &> /dev/null; then
    podmanVersion=$(podman --version)
    echo "Podman encontrado: $podmanVersion"
else
    echo "Podman NAO encontrado"
fi

echo ""
echo "=== Verificando instalacao do podman-compose ==="

if command -v podman-compose &> /dev/null; then
    composeVersion=$(podman-compose --version | grep 'podman-compose version')
    echo "podman-compose encontrado: $composeVersion"
else
    echo "podman-compose NAO encontrado"
fi

echo ""
echo "=== Verificacao finalizada ==="

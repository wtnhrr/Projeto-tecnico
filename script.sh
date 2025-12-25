#!/bin/bash

set -e  # Para o script em caso de erro

echo "Instalando dependência para Makefile (make)..."
apt-get install -y make

echo "Removendo pacotes antigos do Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg || true
done

echo "Atualizando repositórios e instalando dependências..."
apt-get update
apt-get install -y ca-certificates curl gnupg

echo "Adicionando chave GPG oficial do Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "Adicionando repositório oficial do Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Instalando Docker Engine e plugins..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker instalado com sucesso!"
docker --version

echo "Baixando kubectl versão v1.33.0..."
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"

echo "Verificando integridade do kubectl..."
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

echo "Instalando kubectl no /usr/local/bin..."
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Verificando instalação do kubectl..."
kubectl version --client

echo "Instalação completa!"
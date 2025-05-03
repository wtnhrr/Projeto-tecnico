# Documentação do Projeto Kubernetes com Jenkins

## Instalação do Kubernetes (kubectl)

### Download do binário
```bash
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
```

### Validação do binário
```bash
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
```

### Instalação do kubectl
```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Verificação da instalação
```bash
kubectl version --client
```

---

## Instalação do Minikube

### Download do binário
```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
```

### Instalação do Minikube
```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

### Configuração do Docker para Minikube
```bash
sudo usermod -aG docker $USER && newgrp docker
```

### Inicialização do Minikube
```bash
minikube start
```

### Ativação do ambiente Docker do Minikube
```bash
eval $(minikube docker-env)
```

---

## Recuperação da Senha Inicial do Jenkins

### Comando para obter o nome do pod do Jenkins
```bash
POD_NAME=$(kubectl get pods -n jenkins-monitoring -o jsonpath="{.items[0].metadata.name}")
```

### Comando para exibir a senha inicial do Jenkins
```bash
kubectl exec -it $POD_NAME -n jenkins-monitoring -- cat /root/.jenkins/secrets/initialAdminPassword
```

---

## Estrutura do Projeto

### Diretórios e Arquivos
- **kubectl**: Binário do Kubernetes.
- **kubectl.sha256**: Arquivo de verificação do binário do Kubernetes.
- **README.md**: Documentação do projeto.
- **docker/**: Contém arquivos relacionados ao Docker.
  - **Dockerfile**: Arquivo de configuração para criação de imagens Docker.
  - **conf/**: Configurações adicionais.
    - **context.xml**: Configuração do contexto.
    - **tomcat-users.xml**: Configuração de usuários do Tomcat.
  - **war/**: Arquivos WAR para deploy.
    - **jenkins.war**: Arquivo WAR do Jenkins.
    - **jolokia.war**: Arquivo WAR do Jolokia.
- **k8s/**: Arquivos de configuração do Kubernetes.
  - **deployment.yml**: Configuração de deployment.
  - **namespace.yml**: Configuração de namespace.
  - **service.yml**: Configuração de serviço.
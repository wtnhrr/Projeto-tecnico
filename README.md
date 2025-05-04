kubectl apply -f configmap-jolokia.yml
kubectl apply -f jolokia-deployment.yml
kubectl apply -f jolokia-service.yml

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

### Ativação do ambiente Docker do Minikube
```bash
eval $(minikube docker-env)
```

### Inicialização do Minikube
```bash
minikube start --drive=docker
```

---

## Configuração do context.xml e tomcat-users.xml

Antes de construir a imagem Docker, é importante revisar e ajustar os arquivos `context.xml` e `tomcat-users.xml` localizados no diretório `docker/conf/`.

### context.xml
O arquivo `context.xml` configura o contexto do Tomcat. Ele inclui definições como:
- **`antiResourceLocking`**: Define se os recursos devem ser bloqueados durante o uso. Configurado como `false`.
- **`privileged`**: Permite operações privilegiadas, configurado como `true`.
- **`CookieProcessor`**: Configura cookies para o padrão RFC6265 com `sameSiteCookies` definido como `strict`.
- **`Manager`**: Filtra atributos de sessão para maior segurança.

### tomcat-users.xml
O arquivo `tomcat-users.xml` gerencia usuários e permissões no Tomcat. Ele inclui:
- **Roles (Funções)**: Permissões como `manager-gui` e `admin-gui`.
- **Usuários**: Configurações de usuários com nome, senha e funções associadas. **Recomenda-se alterar as credenciais padrão antes de usar em produção.**

Certifique-se de ajustar esses arquivos conforme necessário antes de prosseguir com a construção da imagem Docker.

---

## Build Imagem

### Construindo imagem Dockerfile

Navegue para o diretório docker.
```bash
docker build -t [nome_imagem] .
```


## Kubernetes deployment

### Navegue para o diretório k8s
```bash
kubectl apply -f namespace.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

### Verificar os pods
```bash
kubectl get pods -n jenkins-monitoring
```

### Verificar url
```bash
minikube service jenkins-service -n jenkins-monitoring --url
```

---

## Aplicações do projeto

### Tomcat server
[ip:30000/]

### Jenkins
[ip:30000/jenkins]

### Jenkins password comando para facilitar
```bash
kubectl exec -it jenkins-deployment-8557785d48-6gw2p -n jenkins-monitoring -- cat /root/.jenkins/secrets/initialAdminPassword
```

### Jolokia
[ip:30000/jolokia]

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

- - -
# Documentação do Projeto Kubernetes com Jenkins

Para este projeto utilizaremos minikube para criar um cluster localmente. Lembre-se de fazer a instalação das seguintes aplicações:
- Docker
- Kubectl
- Minikube
- Makefile

- - -
### Passo a Passo para execução do projeto

#### Instalar as depêndecias, utilize o script.sh
De Permissão:
```bash
chmod +x script.sh
```

Execute:
```bash
sudo ./script.sh
```
#### Instalar Minikube
```bash
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
```

#### Verificação da instalação do kubectl
```bash
kubectl version --client
```

#### Configuração do Docker para Minikube
```bash
sudo usermod -aG docker $USER && newgrp docker
```

---

### Configuração do context.xml e tomcat-users.xml

Antes de construir a imagem Docker, é importante revisar e ajustar os arquivos `context.xml` e `tomcat-users.xml` localizados no diretório `docker/conf/`.

#### tomcat-users.xml
O arquivo `tomcat-users.xml` gerencia usuários e permissões no Tomcat. Ele inclui:
- **Roles (Funções)**: Permissões como `manager-gui` e `admin-gui`.
- **Usuários**: Configurações de usuários com nome, senha e funções associadas. **Recomenda-se alterar as credenciais padrão antes de usar em produção.**

Certifique-se de ajustar esses arquivos conforme necessário antes de prosseguir com a construção da imagem Docker.

---

#### Build imagem apenas para o docker
```bash
make jenkins-build
```

#### Deploy da imagem
```bash
docker run -d -p 8080:8080 "nome_da_imagem"
```
A partir daqui pode-se acessar a interface web em http[:]//localhost[:]8080, lembrando-se da senha colocada no tomcat-users.xml

### Kubernetes

#### Inicialização do Minikube
```bash
make start
```

#### Ativação do ambiente Docker do Minikube
```bash
eval $(minikube docker-env)
```

#### Certifique que o ambiente foi ativado
```bash
docker images
```
Deverá aparecer várias imagems funcionais do kubernetes

#### Aqui faça a build da imagem do dockerfile
```bash
make jenkins-build
```

#### E podemos fazer então deploy do cluster
```bash
make k8s-deploy
```
Para consultar pods e urls, para facilitar utilize 'make pods' e 'make url'

---
#### Jenkins password comando para facilitar

Use o comando abaixo para facilitar recuperar a senha do jenkins no primeiro login:
Verifique com 'make pods' o ID do pod para executar o comando abaixo:

```bash
kubectl exec -it jenkins-deployment-'troque o ID' -n jenkins-monitoring -- cat /root/.jenkins/secrets/initialAdminPassword
```

### Prometheus
#### Para fazer deploy do prometheus:
```bash
make prometheus-build
```

---

Abaixo estão as portas de cada aplicação do projeto:
#### Tomcat server
```bash
[ip:30000/]
```

#### Jenkins
```bash
[ip:30000/jenkins]
```

#### Jolokia
```bash
[ip:30000/jolokia]
```

#### Prometheus
```bash
[ip:30090/]
```

Para facilitação foi criado um Makefile para gerênciar. No diretório raiz, execute os comandos:

#### Iniciar o minikube

```bash
make start
```

#### Build da imagem

```bash
make jenkins-build
```

#### Kubernetes deployment
```bash
make k8s-deploy
```

#### Prometheus deployment
```bash
make prometheus
```

#### Verificar pods
```bash
make pods
```

#### Verificar url
```bash
make url
```

#### Limpar pods/service/deployment
```bash
make clean
```

#### Excluir cluster
```bash
make del
```

#### Minikube delete
```bash
make del
```

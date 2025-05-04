
- - -
# Documentação do Projeto Kubernetes com Jenkins

Para este projeto utilizaremos minikube para criar um cluster localmente. Lembre-se de fazer a instalação das seguintes aplicações:
- Docker
- Kubectl
- Minikube
- Makefile

- - -
### Passo a Passo para execução do projeto

#### Instalar as depêndicas, utilize o script.sh
De Permissão:
```bash
chmod +x script.sh
```

Execute:
```bash
sudo ./script.sh
```

#### Verificação da instalação do kubectl
```bash
kubectl version --client
```

#### Instalação do Minikube

#### Configuração do Docker para Minikube
```bash
sudo usermod -aG docker $USER && newgrp docker
```

#### Inicialização do Minikube
```bash
minikube start --drive=docker
```

#### Ativação do ambiente Docker do Minikube
```bash
eval $(minikube docker-env)
```

#### Certifique que o ambiente foi ativado
```bash
docker images
```
Deverá aparecer as imagems várias funcionais do kubernetes

---

### Configuração do context.xml e tomcat-users.xml

Antes de construir a imagem Docker, é importante revisar e ajustar os arquivos `context.xml` e `tomcat-users.xml` localizados no diretório `docker/conf/`.

#### tomcat-users.xml
O arquivo `tomcat-users.xml` gerencia usuários e permissões no Tomcat. Ele inclui:
- **Roles (Funções)**: Permissões como `manager-gui` e `admin-gui`.
- **Usuários**: Configurações de usuários com nome, senha e funções associadas. **Recomenda-se alterar as credenciais padrão antes de usar em produção.**

Certifique-se de ajustar esses arquivos conforme necessário antes de prosseguir com a construção da imagem Docker.

---
### Build Imagem

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

#### Minikube delete
```bash
make del
```

---
#### Jenkins password comando para facilitar

Use o comando abaixo para facilitar recuperar a senha do jenkins no primeiro login:

```bash
kubectl exec -it jenkins-deployment-8557785d48-6gw2p -n jenkins-monitoring -- cat /root/.jenkins/secrets/initialAdminPassword
```

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
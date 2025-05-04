# Variáveis
KUBECTL_VERSION = v1.33.0
MINIKUBE_VERSION = latest
DOCKER_IMAGE_NAME = jenkins-jolokia
DOCKERFILE_DIR = docker
K8S_DIR = k8s
PROMETHEUS_DIR = prometheus
NODE_EXPORTER_DIR = node-exporter

# Comandos
KUBECTL_BIN = /usr/local/bin/kubectl
MINIKUBE_BIN = /usr/local/bin/minikube

.PHONY:  docker-build k8s-deploy start

# Inicializar o Minikube
start:
	minikube start --driver=docker
	@echo "Minikube iniciado com sucesso"

# Construção da imagem Docker
jenkins-build:
	cd $(DOCKERFILE_DIR) && docker build -t $(DOCKER_IMAGE_NAME) .
	@echo "Imagem Docker $(DOCKER_IMAGE_NAME) criada com sucesso"

# Aplicação dos arquivos de Kubernetes
k8s-deploy:
	kubectl apply -f $(K8S_DIR)/namespace.yml
	kubectl apply -f $(K8S_DIR)/deployment.yml
	kubectl apply -f $(K8S_DIR)/service.yml
	@echo "Arquivos de Kubernetes aplicados com sucesso"

# Verificar status dos pods
pods:
	kubectl get pods -n jenkins-monitoring

# Obter a URL do serviço do Jenkins
url:
	@echo "URL do serviço Jenkins:"
	minikube service jenkins-service -n jenkins-monitoring --url

	@echo "URL do serviço Prometheus:"
	minikube service prometheus -n jenkins-monitoring --url

# Prometheus build
prometheus:
	kubectl apply -f $(PROMETHEUS_DIR)/config-map.yml
	kubectl apply -f $(PROMETHEUS_DIR)/prometheus-deployment.yml
	kubectl apply -f $(PROMETHEUS_DIR)/prometheus-service.yml

	kubectl apply -f $(NODE_EXPORTER_DIR)/deployment.yaml
	kubectl apply -f $(NODE_EXPORTER_DIR)/service.yaml

	@echo "Prometheus configurado com sucesso"

# Limpar os recursos feitos no Kubernetes
clean:
	kubectl delete namespace jenkins-monitoring

# Limpar os recursos do Minikube
del:
	minikube delete
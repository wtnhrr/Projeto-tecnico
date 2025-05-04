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

.PHONY: all kubectl minikube docker-build k8s-deploy start

# Tarefa principal que chama as demais
all: kubectl minikube

# Instalação do kubectl
kubectl:
	curl -LO "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	rm kubectl
	@echo "kubectl instalado com sucesso"
	
# Instalação do Minikube
minikube:
	curl -LO https://github.com/kubernetes/minikube/releases/$(MINIKUBE_VERSION)/download/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
	@echo "Minikube instalado com sucesso"

# Inicializar o Minikube
start:
	minikube start --driver=docker
	@echo "Minikube iniciado com sucesso"

# Construção da imagem Docker
docker-build:
	cd $(DOCKERFILE_DIR) && docker build -t $(DOCKER_IMAGE_NAME) .
	@echo "Imagem Docker $(DOCKER_IMAGE_NAME) criada com sucesso"

# Aplicação dos arquivos de Kubernetes
k8s-deploy:
	kubectl apply -f $(K8S_DIR)/namespace.yml
	kubectl apply -f $(K8S_DIR)/deployment.yml
	kubectl apply -f $(K8S_DIR)/service.yml
	@echo "Arquivos de Kubernetes aplicados com sucesso"

# Verificar status dos pods
check-pods:
	kubectl get pods -n jenkins-monitoring

# Obter a URL do serviço do Jenkins
check-url:
	@echo "URL do serviço Jenkins:"
	minikube service jenkins-service -n jenkins-monitoring --url

	@echo "URL do serviço Prometheus:"
	minikube service prometheus -n jenkins-monitoring --url

destroy:
	minikube delete

# Prometheus build

prometheus-build:
	kubectl apply -f $(PROMETHEUS_DIR)/config-map.yml
	kubectl apply -f $(PROMETHEUS_DIR)/prometheus-deployment.yml
	kubectl apply -f $(PROMETHEUS_DIR)/prometheus-service.yml

	kubectl apply -f $(NODE_EXPORTER_DIR)/deployment.yaml
	kubectl apply -f $(NODE_EXPORTER_DIR)/service.yaml

	@echo "Prometheus configurado com sucesso"

metric-build:
	kubectl apply -f jolokia/metricbeat-config.yml
	kubectl apply -f jolokia/metricbeat-deployment.yml
	kubectl apply -f jolokia/metricbeat-service.yml

	@echo "Prometheus configurado com sucesso"

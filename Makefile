# Create kind cluster
env: cluster ingress ingressFix

cluster:
	kind create cluster --config kind.yaml

ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

ingressFix:
	kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# Build and deploy
build:
	docker build -t mirrord-demo:latest .

uploadDockerImage:
	kind load docker-image mirrord-demo:latest

deploy:
	kubectl apply -f deployment.yaml

install: build uploadDockerImage deploy

uninstall:
	kubectl delete -f deployment.yaml

reinstall: uninstall install
# Test commands
showImages:
	docker exec -ti kind-control-plane crictl images

request:
	curl localhost/demo

runlocal:
	docker run -ti -p 8000:8000 --name mirrord-demo mirrord-demo

forwardService:
	kubectl port-forward service/mirrord-demo 8000:8000

# mirrord commands
mirrord:
	mirrord exec --target pod/mirrord-demo python main.py

# Clean up
deleteCluster:
	kind delete cluster
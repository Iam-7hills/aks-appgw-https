STEP 1
Create Certs - just execute the powershell

Open powershell ---> .\certs_file.ps1

STEP 2 - IN AKS Cluster
1. Create secrets
   	kubectl create secret tls iam7hills-tls --cert=tls.crt --key=tls.key -n default
2. Run Nginx_controller - No changes to existing yaml
   	kubectl apply -f nginx-ingress.yaml
4. Deploy the app and services - No changes to existing yaml
   	kubectl apply -f first_app.yaml
	kubectl apply -f second_app.yaml
	kubectl apply -f third_app.yaml

6. Deploy the ingress yaml - Yes minimal changes
	kubectl apply -f routing_ingress.yaml

   Test the application inside the cluster
   curl -vk https://10.0.0.8/first_app -H "Host: www.iam7hills.com"


STEP 3
Create App Gateway
	Backend Pool 
	Routing rule/Listener
	Backend settings --- Upload CRT and CER file
	
STEP 4
Test the application

Diagram
           ┌───────────────┐
           │   Browser /   │
           │  Client App   │
           └───────┬───────┘
                   │ HTTPS (443)
                   ▼
           ┌───────────────┐
           │ Application   │
           │   Gateway     │
           │ (Public IP)   │
           ├───────────────┤
           │ Listener:     │
           │ HTTPS 443     │
           │ PFX cert      │
           ├───────────────┤
           │ Backend Pool  │
           │ Target: AKS   │
           │ Internal LB   │
           ├───────────────┤
           │ HTTP Settings │
           │ Backend TLS   │
           │ RootCA .cer   │
           └───────┬───────┘
                   │ HTTPS (re-encrypt)
                   ▼
           ┌───────────────┐
           │ AKS Cluster   │
           │ NGINX Ingress │
           │ (Internal LB) │
           │ TLS secret    │
           │ tls.crt + key │
           └───────┬───────┘
                   │ HTTP/HTTPS routing
                   ▼
        ┌──────────────────────┐
        │   Kubernetes Pods    │
        │ first-app / second-app│
        │ third-app            │
        └──────────────────────┘


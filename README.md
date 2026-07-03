# 🚀 DevOps Assessment

A production-inspired DevOps project demonstrating the complete CI/CD workflow using **Terraform**, **Docker**, **GitHub Actions**, **Amazon ECR**, **Amazon EKS**, and **Kubernetes**.

The application consists of a frontend and backend deployed on Amazon EKS with an AWS Application Load Balancer (ALB) Ingress.

---

# 📌 Project Overview

This project automates the deployment of a containerized full-stack application to Amazon EKS.

The infrastructure is provisioned using Terraform, Docker images are built and pushed to Amazon ECR through GitHub Actions, and Kubernetes manifests deploy the application into the cluster.

---

# 🏗 Architecture

```text
                     GitHub Repository
                            │
                            ▼
                    GitHub Actions (CI)
            ┌────────────────────────────┐
            │ Build Docker Images        │
            │ Push Images to Amazon ECR  │
            └────────────────────────────┘
                            │
                            ▼
                      Amazon ECR
                            │
                            ▼
                    Amazon EKS Cluster
                  ┌────────────────────┐
                  │ Backend Deployment │
                  │ Frontend Deployment│
                  └────────────────────┘
                            │
                     Kubernetes Services
                            │
                            ▼
                AWS Load Balancer Controller
                            │
                            ▼
             AWS Application Load Balancer (ALB)
                            │
                            ▼
                         End Users
```

---

# 📂 Repository Structure

```text
.
├── backend/
│   ├── Dockerfile
│   └── ...
│
├── frontend/
│   ├── Dockerfile
│   └── ...
│
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── vpc/
│       ├── eks/
│       └── ecr/
│
├── k8s/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── ingress.yaml
│
└── .github/
    └── workflows/
        ├── backend.yml
        └── frontend.yml
```

---

# ⚙️ Tech Stack

* AWS

  * Amazon EKS
  * Amazon ECR
  * Application Load Balancer
  * IAM
  * VPC

* Infrastructure as Code

  * Terraform

* Containerization

  * Docker

* CI/CD

  * GitHub Actions

* Orchestration

  * Kubernetes

---

# ✨ Features

* Infrastructure provisioning using Terraform
* Dockerized frontend and backend
* CI pipeline with GitHub Actions
* Automatic image push to Amazon ECR
* Kubernetes Deployments
* Kubernetes Services
* AWS ALB Ingress
* ConfigMaps
* Kubernetes Secrets
* Readiness Probes
* Liveness Probes
* Resource Requests & Limits
* High Availability using multiple replicas

---

# 🚀 CI/CD Workflow

1. Developer pushes code to GitHub.
2. GitHub Actions builds Docker images.
3. Images are pushed to Amazon ECR.
4. Kubernetes Deployments use the latest images.
5. Amazon EKS updates the running application.
6. AWS ALB exposes the application to the Internet.

---

# ☁ Infrastructure

Terraform provisions:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Amazon EKS Cluster
* Managed Node Group
* Amazon ECR Repositories
* CloudWatch Log Group

---

# ☸ Kubernetes Resources

* Deployment
* Service
* Ingress
* ConfigMap
* Secret

---

# 🔐 Security

* IAM Roles
* IAM Service Account (IRSA)
* Kubernetes Secrets
* Private ECR Images

---

# 📈 High Availability

* Multiple pod replicas
* Kubernetes rolling updates
* AWS Application Load Balancer
* Kubernetes readiness and liveness probes

---

# 🛠 Deployment

## Clone Repository

```bash
git clone https://github.com/<YOUR_USERNAME>/Devops-Assessment.git

cd Devops-Assessment
```

---

## Provision Infrastructure

```bash
cd terraform

terraform init

terraform plan

terraform apply
```

---

## Configure kubectl

```bash
aws eks update-kubeconfig \
    --region us-east-1 \
    --name devops-assessment-cluster
```

---

## Deploy Application

```bash
kubectl apply -f k8s/
```

---

## Verify Deployment

```bash
kubectl get pods

kubectl get svc

kubectl get ingress
```

---

# 📦 GitHub Actions

GitHub Actions automatically:

* Build Docker Images
* Authenticate with AWS
* Push Images to Amazon ECR
* Deploy updated containers to Amazon EKS

---

# 📸 Sample Output

```
Frontend

DevOps Assessment Frontend

This page calls the backend API to check its status.

Backend status:
{"backend":{"status":"ok"}}
```

---

# 📋 Future Improvements

* HTTPS with AWS Certificate Manager
* Custom Domain using Route53
* Horizontal Pod Autoscaler
* Cluster Autoscaler
* Prometheus Monitoring
* Grafana Dashboards
* ArgoCD GitOps
* Helm Charts
* Blue/Green Deployment
* Canary Deployment

---

# 👨‍💻 Author

**Md Shourawandy**

GitHub: https://github.com/Shourawandy

LinkedIn: https://www.linkedin.com/in/md-shourawandy

---

# 📄 License

This project is created for educational and assessment purposes.

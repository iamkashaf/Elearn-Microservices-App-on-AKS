# 🚀 Elearn Microservices App on AKS

This project demonstrates a **full-stack microservices deployment on
Azure Kubernetes Service (AKS)**.

------------------------------------------------------------------------

# 🧱 Architecture

User → Frontend (NGINX) → Backend API (.NET) → MySQL (Persistent
Storage - PVC)

------------------------------------------------------------------------

# ⚙️ Prerequisites

-   Azure CLI
-   Docker
-   kubectl
-   Node.js
-   Terraform

------------------------------------------------------------------------

# 🚀 1️⃣ Infrastructure Setup

cd terraform

terraform init terraform apply -auto-approve

------------------------------------------------------------------------

# 🔐 2️⃣ Login & ACR Setup

az login az account set --subscription "Azure subscription 1" az acr
login --name `<acr-name>`{=html}

------------------------------------------------------------------------

# 🔗 3️⃣ Attach ACR to AKS

az aks update -n `<aks-name>`{=html} -g `<rg-name>`{=html} --attach-acr
`<acr-name>`{=html}

------------------------------------------------------------------------

# ☸️ 4️⃣ Connect to AKS

az aks get-credentials --name `<aks-name>`{=html} --resource-group
`<rg-name>`{=html} kubectl get nodes

------------------------------------------------------------------------

# 🔧 5️⃣ Configure Frontend API

Update: app/frontend/src/pages/Home.js
app/frontend/src/pages/AddNewCourse.js

Use: axios.get('/api/courses') axios.post('/api/courses', courseData)

------------------------------------------------------------------------

# 🐳 6️⃣ Build & Push Docker Images

Backend: cd app/backend docker build -t backend . docker tag backend
`<acr-name>`{=html}.azurecr.io/backend:latest docker push
`<acr-name>`{=html}.azurecr.io/backend:latest

Frontend: cd app/frontend npm install npm run build docker build -t
frontend . docker tag frontend
`<acr-name>`{=html}.azurecr.io/frontend:latest docker push
`<acr-name>`{=html}.azurecr.io/frontend:latest

------------------------------------------------------------------------

# 🔐 7️⃣ Create Kubernetes Secret

kubectl apply -f k8s/mysql-secret.yaml

------------------------------------------------------------------------

# 💾 8️⃣ Create PVC

kubectl apply -f k8s/mysql-pvc.yaml

------------------------------------------------------------------------

# 🗄️ 9️⃣ Deploy MySQL

kubectl apply -f k8s/mysql.yaml

------------------------------------------------------------------------

# 🔧 🔟 Deploy Backend & Frontend

kubectl apply -f k8s/backend.yaml kubectl apply -f k8s/frontend.yaml

------------------------------------------------------------------------

# 🔍 1️⃣1️⃣ Verify

kubectl get pods kubectl get svc kubectl get pvc

------------------------------------------------------------------------

# 🌐 1️⃣2️⃣ Access Application

kubectl get svc frontend-service

Open: http://`<EXTERNAL-IP>`{=html}

------------------------------------------------------------------------

# 🗄️ 1️⃣3️⃣ Initialize Database

kubectl get pods -l app=mysql kubectl exec -it `<mysql-pod>`{=html} --
bash mysql -u root -p

Password: `<your-db-password>`{=html}

------------------------------------------------------------------------

USE elearn_db;

CREATE TABLE Courses ( CourseId INT PRIMARY KEY AUTO_INCREMENT,
CourseName VARCHAR(255), InstructorName VARCHAR(255), Lessons JSON );

INSERT INTO Courses (CourseName, InstructorName, Lessons) VALUES
('DevOps Mastery','Kashaf',
JSON_ARRAY('Docker','Kubernetes','Terraform'));

------------------------------------------------------------------------

# 🎯 Summary

-   AKS deployed
-   Frontend + Backend working
-   MySQL with PVC
-   Secure secrets

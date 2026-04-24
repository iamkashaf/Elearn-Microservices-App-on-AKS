# 🚀 Elearn Microservices App on AKS

This project demonstrates a **full-stack microservices deployment on Azure Kubernetes Service (AKS)**.

---

# 🧱 Architecture

User → Frontend (NGINX)
     → Backend API (.NET)
     → MySQL (Persistent Storage - PVC)

---

# ⚙️ Prerequisites

- Azure CLI  
- Docker  
- kubectl  
- Node.js  
- Terraform  

---

# 🚀 1️⃣ Infrastructure Setup

cd terraform

terraform init
terraform apply -auto-approve

---

# 🔐 2️⃣ Login & ACR Setup

az login
az account set --subscription "Azure subscription 1"
az acr login --name <acr-name>

---

# 🔗 3️⃣ Attach ACR to AKS

az aks update -n <aks-name> -g <rg-name> --attach-acr <acr-name>

---

# ☸️ 4️⃣ Connect to AKS

az aks get-credentials --name <aks-name> --resource-group <rg-name>
kubectl get nodes

---

# 🔧 5️⃣ Configure Frontend API

Update:

app/frontend/src/pages/Home.js  
app/frontend/src/pages/AddNewCourse.js  

## ❌ Old (Local)


axios.get('http://localhost:5256/api/Course')
axios.post('http://localhost:5256/api/Course')

Use:

axios.get('/api/courses')  
axios.post('/api/courses')  

---

# 🔧 6️⃣ Configure Backend Database Connection

## ❌ Old (Local)

"DefaultConnection": "Server=localhost;Database=elearn_db;User=root;Password=rootpassword;"

Update:

app/backend/appsettings.json  

Use:

"DefaultConnection": "Server=mysql;Database=elearn_db;User=root;Password=<your-db-password>;"

---

# 🐳 7️⃣ Build & Push Docker Images

## Backend

cd app/backend  

docker build -t backend .  
docker tag backend <acr-name>.azurecr.io/backend:latest  
docker push <acr-name>.azurecr.io/backend:latest  

## Frontend

cd app/frontend  

npm install  
npm run build  

docker build -t frontend .  
docker tag frontend <acr-name>.azurecr.io/frontend:latest  
docker push <acr-name>.azurecr.io/frontend:latest  

---

# 🔐 8️⃣ Create Kubernetes Secret

kubectl apply -f k8s/mysql-secret.yaml  

---

# 💾 9️⃣ Create PVC

kubectl apply -f k8s/mysql-pvc.yaml  

---

# 🗄️ 🔟 Deploy MySQL

kubectl apply -f k8s/mysql.yaml  

---

# 🔧 1️⃣1️⃣ Deploy Backend & Frontend

kubectl apply -f k8s/backend.yaml  
kubectl apply -f k8s/frontend.yaml  

---

# 🔍 1️⃣2️⃣ Verify

kubectl get pods  
kubectl get svc  
kubectl get pvc  

---

# 🌐 1️⃣3️⃣ Access Application

kubectl get svc frontend-service  

Open: http://<EXTERNAL-IP>

---

# 🗄️ 1️⃣4️⃣ Initialize Database

kubectl get pods -l app=mysql  
kubectl exec -it <mysql-pod> -- bash  
mysql -u root -p  

Password: <your-db-password>  

SQL:

USE elearn_db;

CREATE TABLE Courses (
  CourseId INT PRIMARY KEY AUTO_INCREMENT,
  CourseName VARCHAR(255),
  InstructorName VARCHAR(255),
  Lessons JSON
);

INSERT INTO Courses (CourseName, InstructorName, Lessons)
VALUES ('DevOps Mastery','Kashaf', JSON_ARRAY('Docker','Kubernetes','Terraform'));

---

# 🎯 Summary

- AKS deployment complete  
- Frontend + Backend connected  
- Persistent MySQL using PVC  
- Secure password using Kubernetes Secret  

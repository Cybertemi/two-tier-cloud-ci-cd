
### Two-Tier Web Application Deployment (CI/CD)

📘 Project Overview

This project demonstrates the deployment of a two-tier Django web application using Docker, Jenkins CI/CD, and AWS EC2 with a pipeline that automates application build, image push to Docker Hub, and deployment to a live EC2 instance.

The objective is to showcase real-world DevOps practices such as containerization, automation, and secure cloud deployment.

### Prerequisites

Programming Language: Python (Django)

Containerization: Docker & Docker Compose

CI/CD Tool: Jenkins

Cloud Platform: AWS EC2 (Ubuntu 22.04)

Container Registry: Docker Hub

Version Control: Git & GitHub


###  CI/CD Workflow
1. Code pushed to GitHub repository
2. Jenkins pipeline triggered automatically
3. Docker image built and pushed to Docker Hub
4. EC2 instance pulled the latest image
5. Application deployed using Docker Compose
6. App accessed via EC2 public IP

### Sreenshots for Documentation


001-Docker_image_built.png
02_app_running_locally_using_docker.png
03.Jenkins_pipeline_successful.png
04.ec2_ssh_connection.png
05.creation_of_deploy.sh_in_ec2_terminal
06.docker_compose_running.png
07.app_successful_run_on_ec2_terminal.png
ec2_on_AWS.png


### Application Access
The application is accessible via: http://<Ec2_PUBLIC_IP>:9000

### Step-by-Step: Deploying a Two-Tier App to AWS EC2 Using Docker & Jenkins


✅ STEP 1: Clone the Project Repository

On your local machine or Jenkins agent:

git clone https://github.com/Cybertemi/two-tier-cloud-ci-cd.git
cd two-tier-cloud-ci-cd


✅ STEP 2: Build Docker Image Locally (Testing Phase)

Before CI/CD, confirm the app builds locally.

docker build -t myapp:latest .


Verify:

docker images

✅ STEP 3: Run Locally With Docker Compose
docker compose up


Test locally:

http://localhost:9000


✅ STEP 4: Push Image to Docker Hub (via Jenkins)


Jenkinsfile snippet:
docker build -t $DOCKER_USERNAME/myapp:latest .
docker push $DOCKER_USERNAME/myapp:latest


✅ STEP 5: Prepare AWS EC2 Instance
On AWS:

Launch Ubuntu EC2

Open inbound rules:

SSH → 22

App(Custom) → 9000


✅ STEP 6: Install Docker & Docker Compose on EC2 (Handled automatically in deploy.sh):

sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu


Also installs Docker Compose if missing.

✅ STEP 7: Jenkins Deploys to EC2

Jenkins connects to EC2 using SSH:

ssh ubuntu@EC2_PUBLIC_IP


Then run:

bash deploy.sh

✅ STEP 8: Run Container on EC2
docker compose up -d


Verify:

docker ps


Expected output:

myapp   Up   0.0.0.0:9000->8000/tcp

✅ STEP 9: Access Application in Browser

Open browser:

http://<EC2_PUBLIC_IP>:9000


✔ App loads successfully
✔ Deployment complete

Overall, this project showcases my readiness to contribute to real engineering teams by delivering secure, automated, and maintainable cloud-based solutions.

👤 Author

Temitope Ilori
Cloud DevOps Engineer

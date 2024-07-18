# AzurePOC
To show a Proof of Concept (POC) for moving your application to the Kubernetes platform in your company “ABC,” here's a detailed plan including 
all the necessary steps and configurations:

Step 1: Infrastructure Setup

1.1 Setup Kubernetes Cluster using Azure Kubernetes Service (AKS)
1. Install Azure CLI:
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

2. Login to Azure using Device Code:
     az login --use-device-code   

1.2 Setup Terraform for Infrastructure as Code
1. Install Terraform:
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform

2. Define Terraform Configuration (main.tf):
    File is located at terraform/main.tf
   
4. Deploy with Terraform:
     terraform init
     terraform apply


Step 2: Application Setup

2.1 Define Application with Helm Chart
1. Install Helm:
     curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
   
2. Create Helm Chart for your application:
     helm create hello-world
   
3. Modify the default values.yaml to include your application specifics:
     File is located at hello-world/values.yaml

4. Modify default service.yaml to include your application specifics:
     File is located at hello-world/templates/service.yaml
   
2.2 Create a Sample Node.js Application
1. Create a simple Node.js app:
     Files are located at app/app
   
2. Create a Dockerfile:
     File is located at app/Dockerfile
   
3. Build and push the Docker image:
     docker build -t your-docker-repo/hello-world .
     docker push your-docker-repo/hello-world

2.3 Deploy with Helm Chart
1. Deploy to AKS:
     helm install hello-world ./hello-world

Step 3: CI/CD Pipeline Setup

1.1: Jenkins Installation: 
1. Update the System
     sudo apt update
     sudo apt upgrade -y

2. Install Java: 
    sudo apt install openjdk-11-jdk -y
   
3. Add Jenkins Repository: 
     curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

4. Install Jenkins: 
     sudo apt update
     sudo apt install jenkins -y

5. Start and Enable Jenkins: 
     sudo systemctl start jenkins
     sudo systemctl enable jenkins

6. Adjust Firewall: 
      sudo ufw allow 8080
      sudo ufw status

7. Access Jenkins: 
      Open your web browser and go to http://your_server_ip_or_domain:8080
    
8. Unlock Jenkins: 
      sudo cat /var/lib/jenkins/secrets/initialAdminPassword

9. Install Suggested Plugins: 
      On the "Customize Jenkins" page, select "Install suggested plugins".
   
10. Create First Admin User: 
      Fill in the required information and click "Save and Finish".
    
11. Jenkins is Ready: 
      Click "Start using Jenkins".

1.2 Configure Jenkins Credentials
1. Go to Manage Jenkins -> Manage Credentials.
   
2. Add the following credentials: Open Jenkins and Navigate to Manage Jenkins -> Manage Credentials -> (global) -> Add Credentials.
     a. GitHub credentials (username and token)- 
     b. DockerHub credentials (username and token)
     c. Azure Service Principal (client ID, client secret, tenant ID, and subscription ID): 
     d. SSH key for accessing the AKS cluster (if required)
   
1.3 Create a Jenkins Multi-branch Pipeline Job.
      Jenkinsfile is located at root location.

1.4 Set up a GitHub webhook for automatic deployment
1. Set Up Jenkins:
     Install the necessary plugins: "GitHub" and "GitHub Integration".
   
3. Generate a GitHub Personal Access Token:
      Go to GitHub and generate a personal access token with the necessary permissions (repo, admin).

4. Create a Webhook in GitHub:
      a. Go to the repository where you want to create the webhook.
      b. Navigate to Settings -> Webhooks -> Add webhook.
      c. Fill in the webhook details:
         Payload URL: http://<your-jenkins-url>/github-webhook/
         Content type: application/json
         Secret: (optional) A secret token for security.
         Events: Choose "Just the push event" or other events based on your needs.
      d. Click Add webhook.
   
5. Configure Jenkins to Respond to GitHub Webhooks:
      a. In Jenkins, create a new job or configure an existing one.
      b. In the job configuration:
           Under Source Code Management, select Git and enter your repository URL.
           Under Build Triggers, check GitHub hook trigger for GITScm polling.

Step 4: Access Application
1. Get the external IP of your Load Balancer service:
       kubectl get service hello-world -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

2. Update /etc/hosts file with the above address: 
       <IP_ADDRESS> hello-world.local

3. Access your application URL:
       e.g. http://hello-world.local



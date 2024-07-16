pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('priyanka-docker')
        AZURE_CREDENTIALS = credentials('azure-service-principal')
        GITHUB_CREDENTIALS = credentials('priyanka-git')
        RESOURCE_GROUP = 'ABCResourceGroup'
        AKS_CLUSTER = 'ABCCluster'
        DOCKER_REPO = 'priyankasingh06/hello-world'
        IMAGE_TAG = "v1"

         
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'priyanka-git', branch: 'develop', url: 'https://github.com/singh-priyanka-06/azurepoc.git'
            }
         
            
        }

        stage('Build Docker Image') {
            steps {
                script {


                 
                    
                    echo "Logging into DockerHub"
                    sh ' docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
                    docker.withRegistry('https://index.docker.io/v1/', 'priyanka-docker') {
                        def app = docker.build("${DOCKER_REPO}:${IMAGE_TAG}", "--file app/Dockerfile .")
                        app.push()
                    }
                }
            }
        }


        stage('Deploy with Terraform') {
            steps {
                withCredentials([string(credentialsId: 'azure-service-principal', variable: 'AZURE_CREDENTIALS')]) {
                    sh 'az login --service-principal -u ${AZURE_CREDENTIALS_USR} -p ${AZURE_CREDENTIALS_PSW} --tenant ${AZURE_CREDENTIALS_TEN}'
                    sh 'az account set --subscription ${AZURE_CREDENTIALS_ID}'

                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

       /*
        stage('Deploy with Terraform') {
            steps {
                withCredentials([string(credentialsId: 'azure-service-principal', variable: 'AZURE_CREDENTIALS')]) {
                    sh 'az login --service-principal -u ${AZURE_CREDENTIALS_USR} -p ${AZURE_CREDENTIALS_PSW} --tenant ${AZURE_CREDENTIALS_TEN}'
                    sh 'az account set --subscription ${AZURE_CREDENTIALS_ID}'

                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        



stage('Deploy with Terraform') {
            steps {
                script {
                    def sp = readJSON text: AZURE_CREDENTIALS
                    withCredentials([
                        string(credentialsId: 'azure-client-id', variable: 'CLIENT_ID'),
                        string(credentialsId: 'azure-client-secret', variable: 'CLIENT_SECRET'),
                        string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID')
                    ]) {
                        sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID'
                        sh 'az account set --subscription $sp.subscriptionId'

                        dir('terraform') {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
        
*/
        stage('Deploy with Helm') {
            steps {
                script {
                    sh 'az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER}'
                    sh "helm upgrade --install hello-world ./hello-world --set image.repository=${DOCKER_REPO} --set image.tag=${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

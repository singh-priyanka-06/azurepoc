pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('priyanka-docker')
        AZURE_SERVICE_PRINCIPAL = credentials('azure-service-principal')
        GITHUB_CREDENTIALS = credentials('priyanka-git')
        RESOURCE_GROUP = 'ABCResourceGroup'
        AKS_CLUSTER = 'ABCCluster'
        DOCKER_REPO = 'priyankasingh06/hello-world'
        IMAGE_TAG = "v1"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'priyanka-git', url: 'https://github.com/singh-priyanka-06/azurepoc.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'priyanka-docker') {
                        def app = docker.build("${DOCKER_REPO}:${IMAGE_TAG}")
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

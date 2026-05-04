pipeline {
    agent any
    environment {
        REGISTRY = "docker.io/koohza01"
        IMAGE = "asc-phone-numbers"
        TAG = "latest"
    }
    triggers {
        githubPush()
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/koohza01/asc-phone-numbers.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${REGISTRY}/${IMAGE}:${TAG}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-cred') {
                        docker.image("${REGISTRY}/${IMAGE}:${TAG}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-cred']) {
                    bat 'kubectl apply -f k8s\\deployment.yaml'
                    bat 'kubectl apply -f k8s\\services.yaml'
                }
            }
        }
    }
}

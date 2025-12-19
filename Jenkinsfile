pipeline {
    agent any
    
    tools {
        nodejs 'NodeJS-24'
    }
    
    environment {
        DOCKER_IMAGE = "ttl.sh/nodejs-app-${BUILD_NUMBER}:1h"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Unit Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }
        
        stage('Deploy to Docker') {
            steps {
                sh '''
                    docker stop nodejs-app || true
                    docker rm nodejs-app || true
                '''
                
                sh "docker pull ${DOCKER_IMAGE}"
                sh "docker run -d --name nodejs-app -p 4444:4444 ${DOCKER_IMAGE}"
                
                sh '''
                    sleep 5
                    curl -f http://localhost:4444 || exit 1
                    echo "Docker deployment successful!"
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                // Update the deployment with the ttl.sh image
                sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' k8s/deployment.yaml"
                
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/nodejs-app --timeout=120s
                '''
                
                sh '''
                    kubectl get pods
                    kubectl get services
                    echo "Kubernetes deployment successful!"
                '''
            }
        }
    }
}

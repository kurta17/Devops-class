pipeline {
    agent any
    
    tools {
        nodejs 'NodeJS-24'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'kurta17/nodejs-app'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-credentials'
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
                script {
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").push()
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }
        
        stage('Deploy to Docker') {
            steps {
                script {
                    sh '''
                        docker stop nodejs-app || true
                        docker rm nodejs-app || true
                    '''
                    
                    sh "docker run -d --name nodejs-app -p 4444:4444 ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    
                    sh '''
                        sleep 5
                        curl -f http://localhost:4444 || exit 1
                        echo "Docker deployment successful!"
                    '''
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                        sh """
                            sed -i 's|image: .*|image: ${DOCKER_IMAGE}:${BUILD_NUMBER}|' k8s/deployment.yaml
                        """
                        
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
    }
}

pipeline {
    agent any
    
    tools {
        nodejs 'NodeJS-24'
    }
    
    environment {
        DOCKER_IMAGE = "ttl.sh/nodejs-app-exam:1h"
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
                sh 'fuser -k 4444/tcp || true'
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
        
        // stage('Deploy to Target VM') {
        //     steps {
        //         withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
        //             // Copy files to target
        //             sh 'scp -o StrictHostKeyChecking=no -i $SSH_KEY package.json index.js $SSH_USER@target:~/'
                    
        //             // Install Node.js if needed
        //             sh 'ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@target "which node || (curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash - && sudo apt-get install -y nodejs)"'
                    
        //             // Kill existing process
        //             sh 'ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@target "pkill -f node\\ index.js || true"'
                    
        //             // Install dependencies
        //             sh 'ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@target "cd ~ && npm install --silent"'
                    
        //             // Start app in background - use stdin redirect to prevent SSH hang
        //             sh 'ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@target "cd ~ && nohup node index.js > app.log 2>&1 < /dev/null &"'
                    
        //             // Wait and verify
        //             sh 'sleep 3'
        //             sh 'ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@target "curl -f http://localhost:4444 && echo Target VM deployment successful!"'
        //         }
        //     }
        // }

        stage('Deploy to Docker VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY \$SSH_USER@docker '
                            docker pull ${DOCKER_IMAGE}
                            
                            docker stop nodejs-app || true
                            docker rm nodejs-app || true
                            
                            docker run -d --name nodejs-app -p 4444:4444 ${DOCKER_IMAGE}
                            
                            sleep 3
                            curl -f http://localhost:4444 && echo "Docker VM deployment successful!"
                        '
                    """
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'k8s-token', serverUrl: 'https://kubernetes:6443']) {
                    sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' k8s/deployment.yaml"
                    
                    sh '''
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        kubectl rollout status deployment/myapp --timeout=120s
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

pipeline {
    agent any
    tools {
        go "1.24.1"
    }
    stages {
        stage('Test') {
            steps {
                sh "go test ./..."
            }
        }
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '0db01e01-db84-4fb9-9f5d-6714331439dc', keyFileVariable: 'KEYFILE', usernameVariable: 'USERNAME')]) {
                    // Stop the service if it's running
                    sh 'ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "sudo systemctl stop main.service" || true'
                    
                    // Copy the binary to target
                    sh 'scp -o StrictHostKeyChecking=no -i ${KEYFILE} main ${USERNAME}@target:/home/laborant/'
                    
                    // Make it executable
                    sh 'ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "chmod +x /home/laborant/main"'
                    
                    // Create systemd service file
                    sh '''ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "sudo tee /etc/systemd/system/main.service > /dev/null << 'EOF'
[Unit]
Description=My Application Service
After=network.target

[Service]
ExecStart=/home/laborant/main
WorkingDirectory=/home/laborant
Restart=always
User=laborant

[Install]
WantedBy=multi-user.target
EOF
"'''
                    
                    // Reload systemd and start the service
                    sh 'ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "sudo systemctl daemon-reload"'
                    sh 'ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "sudo systemctl enable main.service"'
                    sh 'ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@target "sudo systemctl start main.service"'
                }
            }
        }
    }
}

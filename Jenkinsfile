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
                sh "go build -o main main.go"
            }
        }
        stage('Deploy') {
              steps {
                  withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                    sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@43.210.19.225 "sudo systemctl stop myapp || true"'
                    sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@43.210.19.225:/tmp/main_new'
                    sh '''ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@43.210.19.225 "
                          sudo mv /tmp/main_new /home/laborant/main &&
                          sudo chmod +x /home/laborant/main &&
                          sudo chown laborant:laborant /home/laborant/main &&
                          sudo systemctl daemon-reload &&
                          sudo systemctl restart myapp &&
                          sudo systemctl status myapp --no-pager"
                      '''
                  }
              }
            }
        }
    }
}

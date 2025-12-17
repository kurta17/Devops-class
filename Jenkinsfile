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
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                    sh '''
                        scp -o StrictHostKeyChecking=no -i ${SSH_KEY} myapp ${SSH_USER}@43.210.19.225:/tmp/myapp
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@43.210.19.225 "
                            sudo mv /tmp/myapp /usr/local/bin/myapp
                            sudo chmod +x /usr/local/bin/myapp
                            sudo systemctl daemon-reload   # in case the unit file changed
                            sudo systemctl restart myapp
                            sudo systemctl status myapp --no-pager
                    '''
                }
            }
        }
    }
}

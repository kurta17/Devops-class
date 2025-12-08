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
        stage('Build Docker image') {
            steps {
                // Unique name every time so we never have conflicts
                sh '''
                    IMAGE=ttl.sh/$(whoami)-myapp-${BUILD_NUMBER}:8h
                    docker build -t $IMAGE .
                    echo "Pushing $IMAGE"
                    docker push $IMAGE
                '''
            }
        }
    }
}

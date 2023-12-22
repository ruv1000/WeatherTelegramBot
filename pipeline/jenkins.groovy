pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick ARCH')

    }
    stages {
        stage('Checkout') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"
            }
        }

        stage('Test') {
            steps{
                echo 'TEST EXECUTION STARTED'
                sh 'make test'
            }
        }

        stage('Build') {
            steps{
                echo 'TEST EXECUTION STARTED'
                sh 'make build'
            }
        }
        
        stage('Push') {
            steps{
                script {
                    docker.withRegistry("",'dockerhub'){
                        echo 'TEST EXECUTION STARTED'
                        sh 'make push'
                    }
                }
                
            }
        }
    }
}
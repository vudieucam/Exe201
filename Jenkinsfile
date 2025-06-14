pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'pettech-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_NETWORK = 'pettech-network'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build with Ant') {
            steps {
                bat 'ant clean dist'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% ."
            }
        }
        
        stage('Create Network') {
            steps {
                bat '''
                    docker network create %DOCKER_NETWORK% || exit 0
                '''
            }
        }
        
        stage('Deploy SQL Server') {
            steps {
                bat '''
                    docker stop mssql || exit 0
                    docker rm mssql || exit 0
                    docker run -d --name mssql ^
                        --network %DOCKER_NETWORK% ^
                        -e "ACCEPT_EULA=Y" ^
                        -e "SA_PASSWORD=YourStrong@Passw0rd" ^
                        -p 1433:1433 ^
                        mcr.microsoft.com/mssql/server:2019-latest
                '''
            }
        }
        
        stage('Deploy Application') {
            steps {
                bat '''
                    docker stop %DOCKER_IMAGE% || exit 0
                    docker rm %DOCKER_IMAGE% || exit 0
                    docker run -d --name %DOCKER_IMAGE% ^
                        --network %DOCKER_NETWORK% ^
                        -p 8080:8080 ^
                        -e DB_HOST=mssql ^
                        -e DB_PORT=1433 ^
                        -e DB_NAME=PetTechDB ^
                        -e DB_USER=sa ^
                        -e DB_PASSWORD=YourStrong@Passw0rd ^
                        %DOCKER_IMAGE%:%DOCKER_TAG%
                '''
            }
        }
    }
    
    post {
        failure {
            bat '''
                docker logs %DOCKER_IMAGE%
                docker logs mssql
            '''
        }
        always {
            cleanWs()
        }
    }
} 
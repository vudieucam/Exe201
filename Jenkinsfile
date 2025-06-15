pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')  // Poll every 5 minutes
    }

    environment {
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk-17'
        TOMCAT_HOME = 'C:\\tomcat\\apache-tomcat-10.1.41'
        MAVEN_HOME = tool 'Maven'
        PATH = "${JAVA_HOME}\\bin;${MAVEN_HOME}\\bin;${env.PATH}"
        TOMCAT_SHUTDOWN_PORT = '9005'
        TOMCAT_HTTP_PORT = '8181'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Deploy WAR') {
            steps {
                bat '''
                    echo "Copying WAR file to Tomcat..."
                    xcopy /y "target\\PetTech.war" "%TOMCAT_HOME%\\webapps\\"
                '''
            }
        }
    }

    post {
        failure {
            bat '''
                echo "Deployment failed! Checking logs..."
                if exist "%TOMCAT_HOME%\\logs\\catalina.out" (
                    type "%TOMCAT_HOME%\\logs\\catalina.out"
                )
                if exist "%TOMCAT_HOME%\\logs\\catalina.%date:~-4,4%-%date:~-7,2%-%date:~-10,2%.log" (
                    type "%TOMCAT_HOME%\\logs\\catalina.%date:~-4,4%-%date:~-7,2%-%date:~-10,2%.log"
                )
            '''
        }
        success {
            echo "🎉 Deployment successful! App is live at: http://localhost:${TOMCAT_HTTP_PORT}/PetTech"
        }
        always {
            cleanWs()
        }
    }
}

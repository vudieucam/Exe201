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

        stage('Stop Tomcat') {
            steps {
                bat '''
                    echo "Stopping Tomcat..."
                    netstat -ano | findstr ":%TOMCAT_HTTP_PORT%" > nul
                    if not errorlevel 1 (
                        cd "%TOMCAT_HOME%\\bin"
                        set CATALINA_HOME=%TOMCAT_HOME%
                        call shutdown.bat

                        :WAIT_LOOP
                        timeout /t 2 /nobreak > nul
                        netstat -ano | findstr ":%TOMCAT_HTTP_PORT%" > nul
                        if not errorlevel 1 (
                            echo "Port %TOMCAT_HTTP_PORT% still in use, waiting..."
                            goto WAIT_LOOP
                        )
                    ) else (
                        echo "Tomcat is not running"
                    )

                    for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%TOMCAT_HTTP_PORT%"') do (
                        taskkill /F /PID %%a 2>nul
                    )

                    if exist "%TOMCAT_HOME%\\temp" (
                        rmdir /s /q "%TOMCAT_HOME%\\temp"
                        mkdir "%TOMCAT_HOME%\\temp"
                    )
                    if exist "%TOMCAT_HOME%\\work" (
                        rmdir /s /q "%TOMCAT_HOME%\\work"
                        mkdir "%TOMCAT_HOME%\\work"
                    )
                    if exist "%TOMCAT_HOME%\\webapps\\PetTech" (
                        rmdir /s /q "%TOMCAT_HOME%\\webapps\\PetTech"
                    )
                    if exist "%TOMCAT_HOME%\\webapps\\PetTech.war" (
                        del /f /q "%TOMCAT_HOME%\\webapps\\PetTech.war"
                    )
                '''
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

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

        stage('Start Tomcat') {
            steps {
                bat '''
                    echo "Starting Tomcat..."
                    cd "%TOMCAT_HOME%\\bin"
                    set CATALINA_HOME=%TOMCAT_HOME%
                    set JAVA_HOME=%JAVA_HOME%
                    call startup.bat

                    :CHECK_STARTUP
                    timeout /t 2 /nobreak > nul
                    netstat -ano | findstr ":%TOMCAT_HTTP_PORT%" > nul
                    if errorlevel 1 (
                        echo "Waiting for Tomcat to start on port %TOMCAT_HTTP_PORT%..."
                        goto CHECK_STARTUP
                    )

                    echo "Tomcat started successfully on port %TOMCAT_HTTP_PORT%"
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                bat '''
                    echo "Verifying deployment..."
                    set MAX_RETRIES=12
                    set RETRY_COUNT=0

                    :VERIFY_LOOP
                    if %RETRY_COUNT% geq %MAX_RETRIES% (
                        echo "Deployment verification failed after %MAX_RETRIES% attempts!"
                        exit 1
                    )

                    if exist "%TOMCAT_HOME%\\webapps\\PetTech\\WEB-INF" (
                        echo "Application deployed successfully!"
                        exit 0
                    ) else (
                        set /a RETRY_COUNT+=1
                        echo "Waiting for deployment... Attempt %RETRY_COUNT% of %MAX_RETRIES%"
                        timeout /t 10 /nobreak
                        goto VERIFY_LOOP
                    )
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

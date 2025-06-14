FROM tomcat:9.0-jdk8-openjdk

# Install SQL Server JDBC driver
RUN wget https://go.microsoft.com/fwlink/?linkid=2222954 -O /tmp/mssql-jdbc.jar && \
    mv /tmp/mssql-jdbc.jar /usr/local/tomcat/lib/

# Copy the WAR file to Tomcat's webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"] 
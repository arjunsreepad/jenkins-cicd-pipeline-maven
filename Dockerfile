# Use the official Tomcat image as the base image
FROM tomcat:9.0

# Copy the WAR file into the webapps directory of Tomcat
COPY target/greetings-0.1.war /usr/local/tomcat/webapps/hello.war

# Expose the port that Tomcat will listen on (default is 8080)
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]


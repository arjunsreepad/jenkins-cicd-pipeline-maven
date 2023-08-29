FROM tomcat:9.0
COPY target/greetings-0.1.war staging_server:/usr/local/tomcat/webapps/hello.war
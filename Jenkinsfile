pipeline{
    agent    any    

    
    stages{
        // Clone from Git
        stage("Clone App from Git"){
            steps{
                echo "====++++  Clone App from Git ++++===="
                git branch:"main", url: "https://github.com/arjunsreepad/jenkins-cicd-pipeline-maven.git"
            }          
        }
        // Build and Unit Test (Maven/JUnit)
        stage("Build and Unit Test (Maven/JUnit)"){
            steps{
                echo "====++++  Build and Unit Test (Maven/JUnit) ++++===="

             //   withMaven {
                sh "mvn clean package"
                junit '**/target/surefire-reports/TEST-*.xml' // Archive the test reports
          //  }          
          }
        }
        
        stage("Static Code Analysis (SonarQube)"){
            steps{
                echo "====++++  Static Code Analysis (SonarQube) ++++===="
                sh "mvn clean package clean package -Dsurefire.skip=true sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=admin -Dsonar.password=admin@123  -Dsonar.projectName=08-jenkins-cicd-pipeline-maven-02-continious-delivery -Dsonar.projectKey=08-jenkins-cicd-pipeline-maven-02-continious-delivery -Dsonar.projectVersion=$BUILD_NUMBER";
               
               
            }           
        }

        stage("Docker Build & Push"){
            steps{
                sh  ''' docker build -t good-day .'''
            }
        }
        stage("Deploy"){
            steps{
                sh  '''
                container_id=$(docker ps -aqf "name=good-day")

                # If it is running, then stop and remove it
                if [ ! -z "$container_id" ]; then
                    echo "Stopping and removing existing container with ID: $container_id"
                    docker stop $container_id
                    docker rm $container_id
                fi

                # Run a new container
                echo "Starting a new good-day container"
                docker run -d -p 9090:8080 --name good-day good-day'''
                    
            }
        }
        
    }
}

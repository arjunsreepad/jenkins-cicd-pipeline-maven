def projectName = 'good-day'

pipeline {
    environment {
		DOCKERHUB_CREDENTIALS=credentials('docker-cred')
	}
    agent any

    stages {
        // Clone from Git
        stage("Clone App from Git") {
            steps {
                echo "====++++  Clone App from Git ++++===="
                git branch: "main", url: "https://github.com/arjunsreepad/jenkins-cicd-pipeline-maven.git"
            }
        }
        
        // Build and Unit Test (Maven/JUnit)
        stage("Build and Unit Test (Maven/JUnit)") {
            steps {
                echo "====++++  Build and Unit Test (Maven/JUnit) ++++===="
                sh "mvn clean package"
                junit '**/target/surefire-reports/TEST-*.xml'
            }
        }
        
        // Static Code Analysis (SonarQube)
        stage("Static Code Analysis (SonarQube)") {
            steps {
                echo "====++++  Static Code Analysis (SonarQube) ++++===="
                withSonarQubeEnv(credentialsId: 'sonar-token', installationName: 'sonarqube') {
                    sh "mvn clean package -Dsurefire.skip=true sonar:sonar -Dsonar.projectName=${projectName} -Dsonar.projectKey=${projectName} -Dsonar.projectVersion=\$BUILD_NUMBER"
                }
            }
        }
        
        // Docker Build & Push
        stage("Docker Build & Push") {
            steps {
                sh "docker build -t arjunsreepad/${projectName} ."
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                sh "docker push arjunsreepad/${projectName}"
            }
        }
        
        // Deploy
        stage("Deploy") {
            steps {
                sh '''
                container_id=$(docker ps -aqf "name=''' + projectName + '''")

                if [ ! -z "$container_id" ]; then
                    echo "Stopping and removing existing container with ID: $container_id"
                    docker stop $container_id
                    docker rm $container_id
                fi

                echo "Starting a new ''' + projectName + ''' container"
                docker run -d -p 9090:8080 --name=''' + projectName + ''' ''' + projectName + ''' '''
            }
        }
    }
}

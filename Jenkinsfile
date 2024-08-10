pipeline {
    agent any

    tools {
        maven 'maven-3.9.6' // Adjust the Maven version as per your installation
        jdk 'jdk-17' // Adjust the JDK version as per your installation
        git 'git'
    }

    environment {
        GIT_REPO_URL = 'https://github.com/subhashis2018/springboot_cicd_1.git'
        GITHUB_CREDENTIAL_ID= 'github-auth'
        DOCKER_IMAGE = "subhashis2022/springboot_cicd_1"
        DOCKER_TAG = "${env.BUILD_ID}"
        DOCKER_REGISTRY_CREDENTIALS_ID = 'docker-auth'
    }

    parameters {
        choice(
            name: 'BRANCH_NAME', 
            choices: ['main', 'develop', 'feature-branch'], 
            description: 'Choose the branch to build'
        )
        booleanParam(
            name: 'RUN_TESTS', 
            defaultValue: true, 
            description: 'Check if you want to run tests'
        )
        booleanParam(
            name: 'RUN_PMD_ANALYSIS', 
            defaultValue: true, 
            description: 'Check if you want to run PMD analysis'
        )
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git branch: "${params.BRANCH_NAME}", url: "${GIT_REPO_URL}", credentialsId: "${GITHUB_CREDENTIAL_ID}"
                }
            }
        }
        stage('Maven Clean') {
            steps {
                sh 'mvn clean'
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Maven Test') {
            when {
                expression { params.RUN_TESTS }
            }
            steps {
                sh 'mvn test'
            }
        }
        stage('Jacoco Test Report') {
            steps {
                script {
                    sh 'mvn jacoco:report'
                }
            }
            post {
                always {
                    jacoco execPattern: '**/target/jacoco.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
               script {
                echo "Building Docker Image"
                def imageName = "${DOCKER_IMAGE}:${DOCKER_TAG}"
                // Create and use a buildx builder
                sh 'docker buildx create --use --name mybuilder || true'
                sh "docker buildx build --load -t ${imageName} ."
                echo "Docker Image Built"
              }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker Image"
                    def imageName = "${DOCKER_IMAGE}:${DOCKER_TAG}"
                    docker.withRegistry('', "${DOCKER_REGISTRY_CREDENTIALS_ID}") {
                        sh "docker push ${imageName}"
                    }
                    echo "Docker Image Pushed"
                }
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}

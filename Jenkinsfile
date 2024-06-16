pipeline {
    agent any

     tools {
        maven 'maven-3.9.6' // Adjust the Maven version as per your installation
        jdk 'jdk-17' // Adjust the JDK version as per your installation
     }

    environment {
        GIT_REPO_URL = 'https://github.com/subhashis2018/springboot_cicd_1.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${env.BRANCH_NAME}",url: "${GIT_REPO_URL}",credentialsId: 'github-uname-password'
                
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
            steps {
                sh 'mvn test'
            }
        }
        //stage('PMD Analysis') {
        //    steps {
        //      script {
          //        sh 'mvn pmd:pmd'
            //  }
         // }
       //    post {
        //      always {
        //          pmd canComputeNew: false, pattern: '**/target/pmd.xml'
        //      }
       //   }
       // }

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

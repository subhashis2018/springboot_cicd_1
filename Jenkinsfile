pipeline {
    agent any

    tools {
        maven 'maven-3.9.6' // Adjust the Maven version as per your installation
        jdk 'jdk-17' // Adjust the JDK version as per your installation
        git 'git'
    }

    environment {
        GIT_REPO_URL = 'https://github.com/subhashis2018/springboot_cicd_1.git'
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
                    git branch: "${params.BRANCH_NAME}", url: "${GIT_REPO_URL}", credentialsId: 'github-auth'
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
       // stage('PMD Analysis') {
        //    when {
         //       expression { params.RUN_PMD_ANALYSIS }
         //   }
          //  steps {
           //     script {
            //        sh 'mvn pmd:pmd'
            //    }
          //  }
          //  post {
           //     always {
           //         pmd canComputeNew: false, pattern: '**/target/pmd.xml'
            //    }
           // }
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

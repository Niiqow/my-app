pipeline {
    agent any
    environment {
        POSTGRES_DB = 'my-app'
        POSTGRES_USER = 'niiqow'
        POSTGRES_PASSWORD = '2212'

        PATH = "${env.PATH}:/Users/niiqow/.nvm/versions/node/v18.12.1/bin"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy') {
            environment {
                DB_HOST = 'localhost'
                DB_PORT = '5432'
            }
            steps {
                sh 'npm run migrate up'
                sh 'npm start'
            }
        }
    }
}

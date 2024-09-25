pipeline {
    agent any
    stages {
        stage('Check Push') {
            steps {
                script {
                    def branch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    echo "Pushed to branch: ${branch}"
                }
            }
        }
    }
}

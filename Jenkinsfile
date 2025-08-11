pipeline {
    agent any

    environment {
        APP_NAME = "sample-node-app"
        DOCKER_REGISTRY = "harishraju454"
        DEV_PORT = "3001"
        TEST_PORT = "3002"
    }

    parameters {
        booleanParam(name: 'BUILD_DEV', defaultValue: true, description: 'Build & run dev image')
        booleanParam(name: 'BUILD_TEST', defaultValue: true, description: 'Build & run test image')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Harish-raju-454/Jenkins-Docker.git'
            }
        }

        stage('Build Images') {
            steps {
                script {
                    if (params.BUILD_DEV) {
                        sh "docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:dev --build-arg ENVIRONMENT=dev ."
                    }
                    if (params.BUILD_TEST) {
                        sh "docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:test --build-arg ENVIRONMENT=test ."
                    }
                }
            }
        }

        stage('Run Containers') {
            steps {
                script {
                    if (params.BUILD_DEV) {
                        sh """
                            docker rm -f ${APP_NAME}-dev || true
                            docker run -d --name ${APP_NAME}-dev -p ${DEV_PORT}:3000 \
                                -e NODE_ENV=development \
                                ${DOCKER_REGISTRY}/${APP_NAME}:dev
                        """
                    }
                    if (params.BUILD_TEST) {
                        sh """
                            docker rm -f ${APP_NAME}-test || true
                            docker run -d --name ${APP_NAME}-test -p ${TEST_PORT}:3000 \
                                -e NODE_ENV=test \
                                ${DOCKER_REGISTRY}/${APP_NAME}:test
                        """
                    }
                }
            }
        }

        stage('Push Images (main only)') {
            when {
                anyOf {
                    branch 'main'
                    branch 'origin/main'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )]) {
                        sh "echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
                        if (params.BUILD_DEV) {
                            sh "docker push ${DOCKER_REGISTRY}/${APP_NAME}:dev"
                        }
                        if (params.BUILD_TEST) {
                            sh "docker push ${DOCKER_REGISTRY}/${APP_NAME}:test"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker image prune -f || true"
        }
    }
}

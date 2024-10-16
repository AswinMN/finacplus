pipeline {
    agent any
    
    environment {
        K8S_CLUSTER = 'your-k8s-cluster-context'
        K8S_NAMESPACE = 'production' // namespace for blue-green deployments
        BLUE_DEPLOYMENT = 'app-blue'
        GREEN_DEPLOYMENT = 'app-green'
        DOCKER_IMAGE = 'your-app-image'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git branch: 'main', credentialsId: 'git-credentials', url: 'https://github.com/user/repo.git'
            }
        }
        
        stage('Build') {
            steps {
                // Build the application
                sh 'mvn clean package'  // Change this as per your build tool (e.g., Gradle, npm)
            }
        }
        
        stage('Test') {
            steps {
                // Run unit tests
                sh 'mvn test'  // Add any test steps based on the language/framework used
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker Image
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to Docker registry
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        // Blue-Green Deployment
        stage('Blue-Green Deployment') {
            steps {
                script {
                    // Implement the blue-green deployment on Kubernetes
                    sh "kubectl config use-context ${K8S_CLUSTER}"

                    // Deploy to green environment first (the new version)
                    sh "kubectl set image deployment/${GREEN_DEPLOYMENT} app-container=${DOCKER_IMAGE}:${DOCKER_TAG} --namespace=${K8S_NAMESPACE}"

                    // Wait until the green deployment is fully ready
                    sh "kubectl rollout status deployment/${GREEN_DEPLOYMENT} --namespace=${K8S_NAMESPACE}"
                }
            }
        }
        
        stage('Switch Traffic to Green') {
            steps {
                script {
                    // Switch the traffic to the green environment using a Kubernetes service
                    sh "kubectl patch service app-service -p '{\"spec\":{\"selector\":{\"app\":\"green\"}}}' --namespace=${K8S_NAMESPACE}"
                }
            }
        }
    }

    post {
        failure {
            script {
                // If the pipeline fails, rollback to the blue deployment (disaster recovery)
                sh "kubectl patch service app-service -p '{\"spec\":{\"selector\":{\"app\":\"blue\"}}}' --namespace=${K8S_NAMESPACE}"
            }
        }
        success {
            script {
                // Clean up the blue environment after a successful deployment (optional)
                sh "kubectl delete deployment ${BLUE_DEPLOYMENT} --namespace=${K8S_NAMESPACE}"
            }
        }
    }
}

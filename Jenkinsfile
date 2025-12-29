pipeline {
    agent any

    stages {

        stage("Checkout code") {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Cybertemi/two-tier-cloud-ci-cd'
            }
        }

        stage("Build image and push") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DOCKER_CRED',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh """
                        echo "\$DOCKER_PASSWORD" | docker login -u "\$DOCKER_USERNAME" --password-stdin
                        docker build -t "\$DOCKER_USERNAME/myapp:latest" .
                        docker push "\$DOCKER_USERNAME/myapp:latest"
                    """
                }
            }
        }

        stage("Deploy to EC2") {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'EC2_KEY',
                        keyFileVariable: 'EC2_KEY'
                    ),
                    string(
                        credentialsId: 'EC2_HOST',
                        variable: 'EC2_HOST'
                    ),
                ]) {
                    sh """
                        chmod 600 "\$EC2_KEY"

                        ssh -o StrictHostKeyChecking=no -i "\$EC2_KEY" ubuntu@"\$EC2_HOST" << EOF
                          echo "Connected to EC2"
                          export DOCKER_USERNAME="\$DOCKER_USERNAME"
                          export DOCKER_PASSWORD="\$DOCKER_PASSWORD"
                          cd /home/ubuntu
                          bash ~/deploy.sh
                        EOF
                    """
                }
            }
        }
    }
}

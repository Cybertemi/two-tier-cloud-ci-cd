pipeline {
    agent any

    stages {

        stage("Checkout code") {
            steps {
                
                git branch: 'main', url: 'https://github.com/Cybertemi/november_project.git'
            }
        }

        stage("Build image and push") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'DOCKER_CRED', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
                ]) {

                    sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker build -t $DOCKER_USERNAME/myapp:latest -f Dockerfile .
                        docker push $DOCKER_USERNAME/myapp:latest
                    '''
                }
            }
        }

        stage("Deploy to EC2") {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'EC2_KEY', keyFileVariable: 'SSH_KEY'),
                    string(credentialsId: 'EC2_HOST', variable: 'EC2_HOST'),
                    usernamePassword(credentialsId: 'DOCKER_CRED', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
                ]) {

                    sh '''
    chmod 600 "$SSH_KEY"

    ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ubuntu@"$EC2_HOST" << EOF
        echo "Connected to EC2"
        export DOCKER_USERNAME="$DOCKER_USERNAME"
        export DOCKER_PASSWORD="$DOCKER_PASSWORD"
        cd /home/ubuntu
        bash ~/deploy.sh
EOF
'''

                }
            }
        }
    }
}
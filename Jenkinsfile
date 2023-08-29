pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS secret access ID')     // for terraform
        AWS_SECRET_ACCESS_KEY = credentials('AWS sceret access key')  // for terraform
        DOCKER_CRED = credentials('Docker') // This is for docker to push the image
        Muthu = credentials('Muthur')  // This is pem file which Ansible will take it
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '2')
    }

    stages { 
        stage ('build') {
            steps {
                sh '''
                cd shoestop 
                ./build.sh 
                '''     
            }
        }

        stage ('push') {
            steps {
                sh '''
                cd Config/dockerpush
                ./push.sh
                '''
            }
        }

        stage ('server creation'){ // by terraform
            steps {
                sh '''
                cd Config/terraform
                ./infra.sh
                '''
            }
        }

        stage ('deployment') { // by ansible
            steps {
                sh '''
                cd Config/ansible
                ./ansible.sh
                ansible-playbook -i inventory.txt --private-key=$Muthu ansible.yml
                '''
            }
        }
        stage ('Loadbalancer') { // by terraform
            steps {
                sh '''
                cd Config/loadbalancer
                ./lb.sh
                '''
            }
        }

        stage ('Deleting the infra') { // by terraform
            steps {
                //  3 minutes time to check for everything  like infrastructure
                sh '''
                sleep 180 
                cd Config/loadbalancer
                terraform destroy --auto-apply
                cd ..
                cd terraform 
                terraform destroy --auto-apply
                '''
            }
        }
    }
}

// The user_id and group_id varibles is used to be provided to the dockerfile agebt to create a jenkins user and group in the cypress image.
// This might not work in multiple nodes jenknis installations.
def user_id
def group_id
def cluster_exists
node {
  user_id = sh(returnStdout: true, script: 'id -u').trim()
  group_id = sh(returnStdout: true, script: 'id -g').trim()
  cluster_exists = true        
}
pipeline {
    agent any
    stages {
        stage('Lint') {
            agent {
                dockerfile {
                dir "Docker"
                filename "Dockerfile.lint"
                additionalBuildArgs "--build-arg user_id=${user_id} --build-arg group_id=${group_id} --build-arg CYPRESS_CACHE_FOLDER=~/.cache"
             }
            }
            steps {
                sh 'make install'
                sh 'make lint'
                sh '''
                    echo "#*#*#*#*#*# LINTING DOCKERFILE #*#*#*#*#*#"
                    wget -O hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 &&\
                    chmod +x hadolint &&\
                    ./hadolint Docker/Dockerfile.production
                '''
                sh 'make unit-test'
                sh 'make e2e-test'
            }
        }
        stage('Build'){
            steps{
                sh 'docker build -t todo-app -f Docker/Dockerfile.production .'
            }
        }
        stage('Push to Dockerhub'){
            steps{
                withDockerRegistry(credentialsId: 'dockerCredentials', url: ''){
                    sh 'docker tag todo-app youssefsaeed11/devops-capestone-todo-app'
                    sh 'docker login'
                    sh 'docker push youssefsaeed11/devops-capestone-todo-app'
                }
            }
        }
        stage('Check Existing Cluster'){
          steps{
            script{
              try { 
                withAWS(region:'eu-central-1',credentials:'aws-user') {
                sh "aws eks describe-cluster --name Devop-Capstone-Project-Todoapp"
                  }
              }
              catch(all){
                cluster_exists = false
              }
              if (cluster_exists == false ){
                sh "echo \"Cluster doesn't exist\""
              }
            }
         }
        }
        stage('Create Cluster'){
         when{
           allOf{
             expression { cluster_exists == false }
             branch 'master'
           }
         }
         steps{
           sh "echo 'Creating New Cluster This May Take up to 10 minutes ....'"
           withAWS(region:'eu-central-1',credentials:'aws-user') {
            sh "eksctl create cluster -f k8s/cluster.yaml"
         }
         }
       }
        stage('Deploy to EKS/Kubernetes'){
          when{
            branch 'master'
          }
          steps{
            withAWS(region:'eu-central-1',credentials:'aws-user') {
            sh """#!/bin/bash
            export testvar=\$(aws eks update-kubeconfig --name Devop-Capstone-Project-Todoapp 2>&1| cut -d\' \' -f 3)
            kubectl config use-context \$testvar
            """
            
            sh "kubectl apply -f k8s/k8sDeployment.yaml"
            sh "kubectl apply -f k8s/k8sService.yaml"
          }}
        }
  
   }
}

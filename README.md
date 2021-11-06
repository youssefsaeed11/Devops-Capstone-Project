# Udacity Devops Nanodegree Capstone Project

**The Todo app is forked from [dobromir-hristov/todo-app](https://github.com/dobromir-hristov/todo-app)**

## Description

This project consists of deploying a `Todo App` into kubernetes infrastructure on AWS.

Project infrastructure contains the following :

* The todo app source coude forked from [dobromir-hristov/todo-app](https://github.com/dobromir-hristov/todo-app).
* Makefile for the basic installation and running processes.
* Jenkinsfile for the main pipeline used to test, build, publish and deploy the application.
* Docker directory contians: 
    * **Dockerfile.lint** for creating a test and linting image for the source code.
    * **Dockerfile.production** for creating the **Production Ready** image to deploy it in kubernetes.
* k8s directory contains: 
    * **cluster.yaml** contains the configuration for creating kubernetes cluster using the **`eksctl`** tool.
    * **deployment.yaml** for creating a deployment in kubernetes.
    * **service.yaml** for creating a service for the deployment using a **load balancer**

## Warnings

* The jenkins file have in the begining three variables defined `user_id, group_id, cluster_exists` the first two `user_id` and `group_id` are used to provide them to the docekrfile agent as build arguments in the lint stage, they are used to create a **jenkins** user and group inside the container to overcome a bug in the cypress image during the installation of the tool related to the files and directories permissions.

* **This step might not work on multiple nodes (master > slaves) jenkins installation, it's only guaranteed to work on single node jenkins**

* Deploying this app will create instances of the type **`t3.medium`** this is not covered by the AWS free tier, it will also create **`auto scalling groups`** and a **`load balancer`** to provide you with a valid URL to access and use the app.

## Prerequisites for running this project
* Create an **AWS** account from here : [AWS knowledge center](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
* Create a Dockerhub account form here : [Signup to Dockerhub](https://hub.docker.com/signup).
* Create an **Linux EC2** instance on AWS.
    * Install **Docker** on the instance : [Installing Docker](https://docs.docker.com/engine/install).
    * Install **Jenkins** on the instance : [Installing jenkins](https://www.jenkins.io/doc/book/installing/).
    * Install **GIT** on the instance : [Installing GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
    * Configure **aws cli** on the instance : [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
    * Install **eksctl** tool for creating and configuring **EKS** clusters : [Installing eksctl](https://eksctl.io/introduction/#installation).
    * Install **kubectl** tool for managing and configuring kubernetes clusters : [Installing kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
    
    **Make sure that `aws cli` , `eksctl` , `kubectl` are installed in this path `/bin/{TOOL NAME}`**
    * Configure jenkins to use docker
    * Install the following plugins for jenkins:
        1. Blue Ocean
        2. CloudBees AWS Credentials Plugin
        3. Docker plugin
        4. Docker Pipeline
        5. Pipeline
        6. Pipeline: AWS Steps
    * Add the **AWS** and **Dockerhub** users credentials to jenkins.
    * Change to your Dockerhub repository in the **Jenkinsfile**  in the **"Push to Dockerhub"** Stage.

## Runnig the project

After you have satisfied all the needs in the **Prerequisites** section you are now ready to run the project.


To run the proejct all you have to do is to fork this project to your github account, go to **`Blue Ocean >> Create a new pipeline >> Github >> select your repository`** And the pipline will run automatically through the defined stages.

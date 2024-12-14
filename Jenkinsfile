pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_REPO_URL = credentials('ecr-repo-url')
  }

  stages {
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/lirazohayon2/Rick-and-Morty-API.git', branch: 'aws-terraform-deployment'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          sh '''
          export AWS_REGION=$AWS_REGION
          terraform init
          terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        sh '''
        python3 -m venv venv
        source venv/bin/activate
        pip install -r requirements.txt
        '''
      }
    }

    stage('Run Tests') {
      steps {
        sh '''
        source venv/bin/activate
        python3 -m unittest discover
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          sh '''
          aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL || echo "ECR login failed"
          docker build -t rick-and-morty-api:latest .
          docker tag rick-and-morty-api:latest $ECR_REPO_URL:latest
          docker push $ECR_REPO_URL:latest
          '''
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        dir('rick-and-morty-chart') {
          sh 'helm upgrade --install rick-and-morty ./ --namespace default'
        }
      }
    }

    stage('Terraform Destroy') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          sh '''
          export AWS_REGION=$AWS_REGION
          terraform destroy -auto-approve
          '''
        }
      }
    }
  }
}

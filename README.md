# Rick and Morty API Project

## Description
This project queries the Rick and Morty API to retrieve characters that meet specific conditions: species as "Human," status as "Alive," and origin as "Earth (C-137)." The results include the character's name, location, and image link. The data is then written to a CSV file and exposed via a REST API using Flask, with support for deployment to AWS using Docker and Terraform.

## Features
- Query the Rick and Morty API for characters based on specific criteria.
- Filter characters by species, status, and origin.
- Store results in a CSV file for easy data management.
- Expose a REST API with Flask for retrieving character data.
- Include a health check endpoint for monitoring API availability.
- Dockerized application for containerized deployment on AWS.
- Infrastructure-as-Code (IaC) with Terraform for automated AWS resource setup.

---

## Deployment to AWS with Terraform and Docker

### 1. AWS Infrastructure Setup using Terraform

Ensure that Terraform and the AWS CLI are installed on your machine.

1. **Clone the repository and switch to the correct branch**
   ```bash
   git clone -b aws-terraform-deployment https://github.com/lirazohayon2/Rick-and-Morty-API.git
   cd Rick-and-Morty-API
   ```

2. **Run Terraform to Set Up AWS Resources**
   Terraform will create a VPC, EC2 instance, security group, and ECR repository.

   ```bash
   terraform init
   terraform apply
   ```

   After completion, Terraform will output the public IP of the EC2 instance.

### 2. Build and Push Docker Image to ECR

1. **Log in to Amazon ECR**
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888577042232.dkr.ecr.us-east-1.amazonaws.com
   ```

2. **Build the Docker Image**
   ```bash
   docker build -t rick_and_morty_api:latest .
   ```

3. **Tag and Push the Docker Image**
   ```bash
   docker tag rick_and_morty_api:latest 888577042232.dkr.ecr.us-east-1.amazonaws.com/rick-and-morty-api:latest
   docker push 888577042232.dkr.ecr.us-east-1.amazonaws.com/rick-and-morty-api:latest
   ```

### 3. Deploy the Docker Container on EC2

1. **SSH into the EC2 Instance**
   ```bash
   ssh -i ~/.ssh/rick-and-morty-key ec2-user@<your-ec2-public-ip>
   ```

2. **Log in to Amazon ECR from EC2**
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 888577042232.dkr.ecr.us-east-1.amazonaws.com
   ```

3. **Pull and Run the Docker Image**
   ```bash
   docker pull 888577042232.dkr.ecr.us-east-1.amazonaws.com/rick-and-morty-api:latest
   docker run -d -p 5000:5000 888577042232.dkr.ecr.us-east-1.amazonaws.com/rick-and-morty-api:latest
   ```

### 4. Test the Application

Once the Docker container is running on EC2, access the application using the public IP:

```bash
curl http://<your-ec2-public-ip>:5000/characters
```

This will return a list of characters from the Rick and Morty API.

### Clean Up

To avoid unnecessary AWS charges, destroy the resources when done:

```bash
terraform destroy
```

--- 

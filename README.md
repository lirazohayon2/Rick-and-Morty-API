# Rick and Morty API Project

## Description
This project queries the Rick and Morty API to retrieve characters that meet specific conditions: species as "Human", status as "Alive", and origin as "Earth (C-137)". The results include the character's name, location, and image link. The data is then written to a CSV file and exposed via a REST API using Flask.

## Features
- Query the Rick and Morty API for characters.
- Filter characters based on species, status, and origin.
- Write results to a CSV file.
- REST API endpoints for fetching character data.
- Health check endpoint.

## Requirements
- The script must query the Rick and Morty API and fetch characters that:
  - Are of species "Human".
  - Have the status "Alive".
  - Originated from "Earth (C-137)".

## Getting Started

### Prerequisites
- Python 3.x
- Flask
- Requests
- Docker
- Kubernetes (Minikube)
- Helm

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/lirazohayon2/Rick-and-Morty-API.git
   cd Rick-and-Morty-API
   ```

2. Set up a virtual environment and install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. Run the application locally:
   ```bash
   python rick_and_morty_script.py
   ```

### Dockerizing the Application
1. Create a Dockerfile that sets up the environment and runs the application.

2. Build the Docker image:
   ```bash
   docker build -t rick_and_morty_api .
   ```

3. Run the Docker container:
   ```bash
   docker run -p 5000:5000 rick_and_morty_api
   ```

### Kubernetes Deployment with Minikube
1. Start Minikube:
   ```bash
   minikube start
   ```

2. Create the deployment using Helm:
   ```bash
   helm install rick-and-morty-release ./rick-and-morty-chart
   ```

3. Access the service:
   ```bash
   minikube service rick-and-morty-service
   ```

### Verifying Kubernetes Deployment

1. After installing the Helm release, verify that the Pods and services are running correctly by executing:
   ```bash
   minikube kubectl -- get pods
   minikube kubectl -- get services
   ```

2. Check that all Pods are in the **Running** state. If the Pods are not running or show errors, use the following command to check the logs:
   ```bash
   minikube kubectl -- logs <pod-name>
   ```

3. Access the service using the following command, which will open the service in the browser:
   ```bash
   minikube service rick-and-morty-service
   ```

Once the service is running, replace `<port>` with the port shown in the Minikube output. For example, if Minikube shows the port as 52633, the URLs would be:

- **Characters Endpoint**: `http://127.0.0.1:52633/characters`
- **Health Check**: `http://127.0.0.1:52633/healthcheck`


### Troubleshooting

1. If you cannot access the service or the API endpoints, you can check the logs of the running Pods to identify any issues:
   ```bash
   minikube kubectl -- logs <pod-name>
   ```

2. This will show you any errors or issues related to the deployment or the Flask application running inside the Pod.

### API Endpoints
- **GET /characters**: Retrieves a list of characters meeting the specified conditions.
- **GET /healthcheck**: Returns the health status of the API.

## CSV Output
The results are written to a file named `rick_and_morty_characters.csv` in the project directory.

## Acknowledgments
- [Rick and Morty API](https://rickandmortyapi.com/documentation/#rest)

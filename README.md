# Node.js DevOps Application

A simple Node.js Express application with a complete CI/CD pipeline using Jenkins.

## Application

The application is a simple Express server that returns a JSON response on the root endpoint.

### Running Locally

```bash
# Install dependencies
npm install

# Run the application
npm start

# Run tests
npm test
```

The application will be available at `http://localhost:4444`

## CI/CD Pipeline (Jenkins)

The Jenkinsfile includes the following stages:

### 1. Checkout
- Checks out the source code from SCM

### 2. Install Dependencies
- Installs Node.js dependencies using npm

### 3. Unit Test
- Runs unit tests using Node.js 24

### 4. Build Docker Image
- Builds Docker image with build number and latest tags

### 5. Push Docker Image
- Pushes to Docker Hub registry

### 6. Deploy to Docker
- Stops existing container (if any)
- Runs new container
- Performs health check

### 7. Deploy to Kubernetes
- Applies Kubernetes manifests (Deployment and Service)
- Verifies the deployment status

## Jenkins Setup Requirements

1. **NodeJS Plugin**: Install and configure NodeJS tool named `NodeJS-24`
2. **Docker Pipeline Plugin**: For Docker build and push
3. **Credentials**:
   - `docker-hub-credentials`: Docker Hub username/password
   - `kubeconfig-credentials`: Kubernetes config file

## Kubernetes Manifests

Located in the `k8s/` directory:
- `deployment.yaml` - Kubernetes Deployment with 2 replicas
- `service.yaml` - LoadBalancer Service exposing port 80

## Docker

```bash
# Build the image
docker build -t nodejs-app .

# Run the container
docker run -p 4444:4444 nodejs-app
```

# Deploy.ps1

# Step 1: Run Automated Tests
Write-Host "Step 1: Running automated tests..."
dotnet test ./super-service/test --logger "trx;LogFileName=testresults.trx"

if ($LastExitCode -ne 0) {
    Write-Error "Tests failed. Aborting deployment."
    exit 1
}

Write-Host "Tests passed successfully."

# Step 2: Package Application as Docker image
Write-Host "Step 2: Packaging application as Docker image..."
cd ./super-service
docker build -t super-service-image .

# Step 3: Deploy and run the Docker image locally or in a public cloud
Write-Host "Step 3: Deploying and running Docker image..."
# Example: Run locally
docker run -d -p 5000:80 --name super-service-container super-service-image

# Example: Run in AWS ECS (replace with your cloud provider's commands)
# aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
# docker tag super-service-image:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/super-service-image:latest
# docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/super-service-image:latest
# aws ecs update-service --cluster <cluster_name> --service <service_name> --force-new-deployment

Write-Host "Deployment complete."


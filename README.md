# Super Service Application

Welcome to the Super Service application repository. This document provides instructions on how to set up and run the application.

## Part 1: Running the Dockerized Application - ## 1. Automated deployment 

### Prerequisites
- Make sure the ports : 80,443,5000 open in the security group
Make sure you have the following installed on your machine:

- Docker (version >= 25.0.3)

### Steps to Run

1. **Clone the Repository:**

   ```bash
   git clone <repository-url>
   cd super-service

2. Build the Docker Image:
sudo docker build -t super-service-image .

3. Run the Docker Container: (Make sure no other application running on same port)
sudo docker run -d -p 5000:80 super-service-image

4. Access the Application:
http://localhost:5000
http://localhost:5000/test


5. Stop the application
sudo docker stop $(sudo docker ps -a -q --filter ancestor=super-service-image --format="{{.ID}}")


## Part 2: Infrastructure

AWS EKS Setup Documentation
1. Prerequisites
AWS account with appropriate permissions to create EKS clusters, IAM roles, VPC, and related resources.
AWS CLI installed and configured.
kubectl command-line tool installed for interacting with Kubernetes clusters.
2. Creating the VPC
Step 1: Create a VPC
Navigate to AWS Management Console > VPC > Create VPC.
Configure public and private subnets across multiple availability zones.
Ensure proper routing tables and network ACLs are set up.
3. Setting Up EKS Cluster
Step 2: Create IAM Roles

Create IAM roles for EKS cluster control plane and worker nodes:
EKS Service Role
Node Instance Role
Step 3: Install eksctl

Install eksctl, a command-line utility for creating and managing EKS clusters:
bash
Copy code
brew tap weaveworks/tap
brew install eksctl
Step 4: Create EKS Cluster

Use eksctl to create the EKS cluster with appropriate configurations:
bash
Copy code
eksctl create cluster \
  --name my-eks-cluster \
  --version 1.21 \
  --region us-west-2 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
Step 5: Configure kubectl

Configure kubectl to connect to the EKS cluster:
bash
Copy code
aws eks --region <region> update-kubeconfig --name <cluster-name>
4. Networking and Security
Step 6: Networking

Ensure the EKS cluster is set up within the VPC with appropriate subnets (public and private).
Use Security Groups and Network ACLs to control inbound and outbound traffic to/from the cluster.
Step 7: Secure Access to Internal Systems

Establish VPN connections or use AWS PrivateLink to securely connect the EKS cluster to the "internal-assets" virtual network.
Configure VPC peering if necessary for communication between VPCs.
5. Deploying Applications
Step 8: Deploying Web Services
Create Kubernetes deployment manifests or use Helm charts to deploy applications.
Expose services securely using Kubernetes Services of type LoadBalancer or Ingress.
Implement SSL termination and configure security policies.
6. Monitoring and Alerting
Step 9: Monitoring
Set up monitoring using AWS CloudWatch or third-party tools integrated with EKS.
Create dashboards and set up alerts for cluster health and application metrics.
7. Continuous Deployment
Step 10: CI/CD Integration
Integrate EKS with CI/CD pipelines (e.g., GitLab CI/CD, GitHub Actions, Jenkins) for automated deployments.
Automate container builds, tests, and deployments using Kubernetes manifests managed via GitOps principles.
8. Troubleshooting and Support
Step 11: Support and Troubleshooting
Document procedures for troubleshooting common issues (e.g., connectivity problems, pod scheduling issues).
Define escalation paths and support contacts for handling critical incidents.


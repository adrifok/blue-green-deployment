blue-green-deployment
Docker-based Todo REST API on AWS EC2 with blue-green deployment. Zero-downtime cutover between slots using Nginx as reverse proxy, automated via GitHub Actions CI/CD.

What gets deployed

Two identical API containers (api-blue, api-green) running behind Nginx on a single EC2 instance. On each deploy, the pipeline starts the idle slot, health checks it, then switches Nginx upstream — no downtime. MongoDB runs as a shared container. Infrastructure is provisioned with Terraform.

Structure

app — Node.js + Express + Mongoose REST API, Dockerfile
nginx — reverse proxy config, upstream block points to active slot
infra — Terraform: EC2 instance, security group (ports 22 and 80 only)
switch.sh — detects active slot, health checks idle slot, swaps Nginx upstream and reloads
.github/workflows/deploy.yml — builds image, pushes to Docker Hub, deploys to EC2, runs cutover

Usage

cd infra
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply

Push to main triggers the full pipeline: build → push → deploy → cutover.

Variables

aws_region — AWS region
ami_id — EC2 AMI ID
instance_type — instance type (default: t2.micro)
key_name — EC2 key pair name
subnet_id — target subnet ID

Endpoints

GET /todos — list all todos
POST /todos — create a todo
PUT /todos/:id — update a todo
DELETE /todos/:id — delete a todo

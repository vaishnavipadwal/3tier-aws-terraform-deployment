# Automating 3-Tier Web App Infrastructure on AWS with Terraform

## Step 1: Preparing the Project Files

First, I created the project folder structure. I separated each part of the infrastructure into modules — like `vpc`, `backend`, `database`, `frontend`, and `lambda`. Each module had its own Terraform files (`main.tf`, `variables.tf`, and `outputs.tf`). For example, the frontend module also had my website’s `index.html`.

## Step 2: Creating the VPC and Subnets

In the VPC module, I defined a custom VPC with two public and two private subnets. I set the public subnets to assign public IPs automatically by adding `map_public_ip_on_launch = true`. I also created a security group allowing inbound SSH (port 22) and HTTP (port 80) traffic from anywhere.

I output the VPC ID, public and private subnet IDs, and the security group ID to use in other modules.

## Step 3: Setting Up the Backend EC2 Instance

For the backend, I launched an EC2 instance inside the **public subnet** (specifically, the first public subnet). I used a free-tier instance type (`t2.micro`). I added a user data script to install Apache and PHP automatically so the backend server would run the PHP app right away.

The security group attached allowed me to SSH into the instance and access the web server via HTTP.


## Step 4: Launching the RDS MySQL Database

I created an RDS MySQL instance inside the **private subnets** using a subnet group. I used a free-tier database instance class (`db.t2.micro`). I set it to not be publicly accessible for security. The backend EC2 instance could connect to this database inside the VPC.


## Step 5: Hosting the Frontend on S3

For the frontend, I created an S3 bucket configured to host a static website. I uploaded my `index.html` file there. Then, I set a bucket policy that allowed public read access to make sure anyone could view the website.

Since AWS blocks public access by default, I disabled the “Block Public Access” settings for this bucket directly in the AWS console to let the policy work.


## Step 6: Packaging and Deploying Lambda (Optional)

I wrote a simple Lambda function in Python. To deploy it, I zipped the Python file using PowerShell with the command:

```powershell
Compress-Archive -Path lambda_function.py -DestinationPath lambda_function_payload.zip
```

This zip file was referenced in Terraform to deploy the Lambda function.

## Step 7: Deploying the Infrastructure

I ran these Terraform commands from my project root folder:

```bash
terraform init
terraform plan
terraform apply
```

When prompted, I typed `yes` to let Terraform create the resources.

## Step 8: Testing and Troubleshooting

* I checked Terraform outputs to get the public subnet IDs and the backend EC2’s public IP.
* I confirmed the EC2 was in the public subnet and had a public IP assigned.
* I SSH’d into the EC2 instance using my key and the public Ip.
* I opened the backend PHP page and frontend S3 URL in the browser to confirm they worked.
---


## Challenges I Faced and How I Fixed Them

### EC2 Was Launching in Private Subnet

Initially, my EC2 instance launched in a private subnet without a public IP, so I couldn’t connect to it. The issue was the Terraform output for `public_subnets` was correct, but I had to confirm the backend module was using `module.vpc.public_subnets[0]` exactly. Also, my public subnet needed `map_public_ip_on_launch = true` to assign public IPs automatically.

### SSH Connection Timeout

Even after that, I couldn’t SSH. Then I checked the security group rules and added inbound rules for port 22 (SSH) and port 80 (HTTP). I also verified the EC2 instance actually had a public IP.

### S3 Bucket Public Access Blocked

When I tried to make the frontend public, Terraform failed applying the bucket policy due to AWS blocking public policies by default. I logged into AWS Console, disabled **Block Public Access** for my S3 bucket, and applied a bucket policy allowing public reads. After this, the frontend website became publicly accessible.

### Missing Lambda Zip File

Terraform was complaining about a missing zip file for Lambda. I created the zip using PowerShell (as shown above), placed it in the Lambda module folder, and then Terraform deployed it successfully.

---

That’s how I automated a scalable 3-tier web app deployment on AWS using Terraform! If you want, I can share the full Terraform code and detailed instructions.


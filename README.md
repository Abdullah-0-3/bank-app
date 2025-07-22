# **Bank Application**

Deployment of a Banking Application using AWS Services

> ![Bank App 1](/assets/bank-app-1.png)
>
>![Bank App 2](/assets/bank-app-2.png)

### **Application Structure**

* Multi-tier application written in Java (SpringBoot)
* MySQL for Database in Application

---

### **Tech Stack**

* GitHub
* Amazon CodeBuild
* Amazon CodeDeploy
* Amazon CodePipeline
* AWS LoadBalancers
* AWS Target Groups
* AWS ECS (Elastic Container Service)
* Amazon ECR (Elastic Container Registry)

---

### **Situation**

Deploy a Java-based two-tier banking application that using MySQL database. Goal was to containerize, automate, and deploy application on AWS using Best DevOps Practices. Implemented fully managed AWS CI/CD Pipeline along with Scalable Architecture.

---

### **Task**

- Containerize the Java Application using Docker
- Migrate local docker-compose to Cloud Native AWS Architecture
- Deploy the applicaton using Amazon ECS (Elastic Container Service) Fargate
- Automate build and deploy process using Amazon CodeBuild and CodePipeline (CI/CD)
- Setting up Public Internet-facing LoadBalancer to manage traffic
- Mapping LoadBalancer to Custom Domain to access the Application on Internet

---

### **Action**

1. **Containerization**

    - Created Dockerfile for SpringBoot Java Application
    - Configured Environment Variables and Volumes for docker-compose file

2. **Infrastructure**

    - Designed custom VPCs, Subnets, Internet Gateways and Route Tables using Best Practices
    - Created ECS Cluster on Fargate defined multi-container Task Defintions running both Bank App and MySQL
    - Setting up ALB (Application Load Balancer) with health checks and Target Groups, forwarding traffic to port 80 from port 8080 of Container

3. **CI/CD Pipeline**

    - Set up AWS CodeBuild with working `buildspec.yml` to build and push Docker image to ECR (Elastic Container Registry)
    - Configured CodePipeline to trigger builds on every push and pull request
    - Integreated CodeDeploy within Pipeline deploying latest Java Image to ECS Cluster automatically

4. **Observability & Debugging**

    - Integreated CloudWatch Logs for both container and Code Pipeline
    - Troubleshooted deployment issues including RollingBack, AlB health configurations, and MySQL Readiness delays

---

### **Result**

- Reduced manual deployment effort by 90% using end-to-end CI/CD Pipeline
- Achieved consistent deployment sppeed of 10 minutes from GitHub Push to ECS Rollout
- Deployed application wiht 100% uptime during cycles and load balancer health checks
- Toubleshoot and fixed 3 critical ECS task crash issues during production
- Increased app accessibility and performance by using ALB + ECS over local docker-compose setup
- Gained hand-on experience with 6+ core AWS Services like VPC, ECS, ECR, CodeBuild, CodePipline, and ALB

---

### **Steps to Deploy**

`In Process`

---

> ![Bank-App-Deployed](/assets/bank-app-deployed.png)
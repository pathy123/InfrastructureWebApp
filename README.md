
 Below are the details of the file structure of infrastructure pipeline -

 Infrastructure files - 
            Terraform/deploy.yml  - This file we used for to create and deployment terraform plan
            Azure-pipeline - start the pipeline , where we have multistage deployment(DEV, PROD)
            dev.tfvars - variable file for DEV
            prod.tfvars - variable file for PROD
            main.tf - main terraform file
            Providers.tf - for azure and other resource provider

Steps to run the infrastructure pipeline  -

        AzureDevops --> azure-pipeline.yml -->Terraform/deploy.yml --> Stage deployemnt -DEV  --> (Approver) --> Stage deployment (Prod)

After deployment in Azure we will have below azure resources -

--> ResourceGroup
--> ApplicationInsights
--> Azure container registry
--> Appserviceplan for container
--> WebApp for container
# Create the serverless Bookstore with terraform

This repository extends [this](https://www.alexedwards.net/blog/serverless-api-with-go-and-aws-lambda) great blog post written by [Alex Edwards](https://github.com/alexedwards/) by using `terraform` to create the final serverless bookstore example.

**If you haven't already make sure you read through and follow the blog post at least once before you begin!**

## Step-by-step guide

_Note that this guide uses the `us-east-1` as the AWS region where everything will be created. You can change the region in the `vars.tf` file but remember to also change the region in the `books/db.go` file and the global `db` variable._

1. [Download](https://www.terraform.io/downloads.html) and [install](https://www.terraform.io/intro/getting-started/install.html) `terraform`
2. Create a new IAM User (i called the user `terraformer`) and generate access keys. Take a note of the `AccessKeyId` and `SecretAccessKey` fields when you generate the access keys below, you'll need them in step 3:
```
aws iam create-user --user-name terraformer
aws iam create-access-keys --user-name terraformer
```
2. Attach the `AdministratorAccess` to the newly created user:
```
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name terraformer
```
3. Create a new `awscli` profile and reference the generated access keys (through `stdin`):
```
aws configure --profile terraformer
```
4. Run `make aws-lambda-build` in the `books/` directory to compile a binary and create the needed zip-file. The zip-file must be present when running `terraform` in the next step!
5. Now run the following `terraform` commands in root of this repository:
```
terraform validate
terraform init
terraform plan
terraform apply
```
When everything is created you'll be presented with an output similar to this:

```
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

books_rest_api_endpoint = https://REST_API_ID.execute-api.REGION.amazonaws.com/staging/books
```

You can use `terraform output` retrieve the `books_rest_api_endpoint` later on. 

To test the serverless bookstore and create a new book through the API:
```
curl -i -H "Content-Type: application/json" -X POST \
-d '{"isbn":"978-0141439587", "title":"Emma", "author": "Jane Austen"}' \
$(terraform output books_rest_api_endpoint)
```

And to get the created book item:
```
curl $(terraform output books_rest_api_endpoint)?isbn=978-0141439587
```

To remove all resource created in AWS you can run `terraform destroy`.

## Overview (GET request)

<p align="center">
    <img src="https://github.com/mikejoh/serverless-bookstore/blob/master/aws-serverless-bookstore-get.png" title="GET request">
</p>

## Terraform

About Terraform (taken from the official homepage):

_HashiCorp Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned._

See the official Terraform Getting Started guide [here](https://www.terraform.io/intro/getting-started/build.html).

Some words on the `terraform` commands that we ran in the guide above:

`terraform validate`, validates the syntax of the `terraform` configuration files.

`terraform init` initializes a working directory containing Terraform configuration files.

`terraform plan` is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

`terraform apply` is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.

`terraform destroy` is used to destroy the Terraform-managed infrastructure.
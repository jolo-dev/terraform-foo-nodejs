# Foo App

## Architecture

![Architecture](aws-arch.png)

## Pre-Requisite

- AWS CLI
- Terraform
- Node
- Docker

### Create an S3 bucket for bootstrap

Exchange the region in the `Makefile` and run

```sh
make bucket
```

The name needs to be remembered and then exchanged in the `BUCKET_NAME` along with the `AWS_REGION` in the `Makefile`.

### Create a role on the AWS Account for Github to deploy

You need to use OpenID connect on AWS for letting Github assume a role.
Please, read [the documenation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) and save the role in a Github Secret `secrets.aws_role_arn`.

To create via CLI (not recommended):

```sh
make openid_connect
```

## Folder Structure

```sh
.
├── app
│   ├── db
│   └── node_modules
└── infrastructure
    └── modules
        ├── database
        ├── instances
        └── networking
```

### app

- `app` needs to be zipped and send to S3 run `make upload_zip`
- `infrastructure` contains the terraform (run `make tf_apply`)

## Deployment

After the [Pre-requisite](#pre-requisite), it should get deployed via GitHub actions.
If not run `make tf_apply` locally.

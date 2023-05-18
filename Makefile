BUCKET_NAME=aws-terraform-$(shell whoami) # Change this to your own bucket name
AWS_REGION=us-east-1
AWS_PROFILE=default

openid_connect:
	aws iam create-open-id-connect-provider \
		--url https://token.actions.githubusercontent.com \
		--thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1 \
		--client-id-list sts.amazonaws.com \
		--region $(AWS_REGION)

bucket:
	# Check if bucket exists, if not, create it
	aws s3api head-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE) || \
	aws s3api create-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE)

zip_app:
	zip -r app.zip ./app -x ./app/node_modules/\* -x ./app/pnpm-lock.yaml -x ./app/.env

upload_app: zip_app
	aws s3 cp app.zip s3://$(BUCKET_NAME)/app.zip
	rm app.zip

tf_init:
	cd infrastructure && terraform init

tf_plan: tf_init
	cd infrastructure && terraform plan

tf_apply: tf_init
	cd infrastructure && terraform apply --auto-approve

tf_destroy:
	cd infrastructure && terraform destroy --auto-approve

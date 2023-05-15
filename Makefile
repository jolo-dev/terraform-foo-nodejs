BUCKET_NAME=aws-terraform-$(shell whoami)
AWS_REGION=us-east-1
AWS_PROFILE=default

bucket:
	# Check if bucket exists, if not, create it
	aws s3api head-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE) || \
	aws s3api create-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(AWS_PROFILE)

zip_app:
	zip -r app.zip app -x app/node_modules/\* -x app/pnpm-lock.yaml -x app/.env

upload_app: zip_app
	aws s3 cp app.zip s3://$(BUCKET_NAME)/app.zip
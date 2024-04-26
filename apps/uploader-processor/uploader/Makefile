uploader-dev:	
	docker build --no-cache -t uploader:dev . \
	&& $$(aws configure export-credentials --format env) \
	&& docker run \
	-it \
	--net=host \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	--env-file=.env \
	--rm \
	-v $(PWD)/src:/app \
	uploader:dev /bin/sh
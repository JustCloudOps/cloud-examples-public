## Notes

Manual build:
docker build -t uploader:1 .

Run local: 
docker run --net=host uploader:1 --env AWS_REGION=us-east-1 --env S3_BUCKET_NAME=mybucket
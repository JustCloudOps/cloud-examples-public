from flask import Flask, render_template, request
import logging
import boto3
import json
import os

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

AWS_REGION = os.environ['AWS_REGION']
S3_BUCKET_NAME = os.environ['S3_BUCKET_NAME']

@app.route('/healthcheck')
def healthcheck():
    #To Do: write a health check that validates s3 connectivity
    return json.dumps({'status': 'ok'}), 200, {'ContentType':'application/json'} 

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    if file:
        # Generate presigned POST data
        logger.info('generating presigned post')
        s3_client = boto3.client('s3', region_name=AWS_REGION)
        s3_client.upload_fileobj(file, S3_BUCKET_NAME, file.filename)

        return render_template('upload.html')
    return 'No file uploaded'

if __name__ == '__main__':
    app.run()
from flask import Flask, render_template, request
import logging
import boto3
import json
import os

AWS_REGION = os.environ['AWS_REGION']
S3_BUCKET_NAME = os.environ['S3_BUCKET_NAME']

s3_client = boto3.client('s3', region_name=AWS_REGION)

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1000 * 1000 #50MB Upload limit
app.logger.setLevel(logging.INFO)

@app.route('/health')
def health():
    try:
        s3_client.head_bucket(Bucket=S3_BUCKET_NAME)
        return json.dumps({'status': 'ok'}), 200, {'ContentType':'application/json'}
    except Exception as e:
        app.logger.error(e)
        return json.dumps({'status': 'failed'}), 503, {'ContentType':'application/json'}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    if file:
        app.logger.info('Starting upload of %s', file.filename)
        s3_client.upload_fileobj(file, S3_BUCKET_NAME, file.filename)
        return render_template('upload.html')
    return 'No file uploaded'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
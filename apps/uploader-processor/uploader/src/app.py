from flask import Flask, render_template, request
import boto3
import os

app = Flask(__name__)

@app.route("/")
def home():
    return render_template('index.html')

@app.route("/upload", methods=['POST'])
def upload():
    file = request.files['file']
    if file:
        # Generate presigned URL
        s3_client = boto3.client('s3', region_name=os.getenv('AWS_REGION'))
        presigned_url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': os.getenv('S3_BUCKET_NAME'),
                'Key': file.filename,
                'ContentType': file.content_type
            },
            ExpiresIn=600  # URL expires in 5 min todaywe
        )
        return render_template('upload.html', presigned_url=presigned_url)
    return 'No file uploaded'

if __name__ == '__main__':
    app.run(debug=True)

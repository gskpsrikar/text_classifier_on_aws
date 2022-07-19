import boto3

s3 = boto3.resource('s3')
buckets = [bucket.name for bucket in s3.buckets.all()]
print(buckets)
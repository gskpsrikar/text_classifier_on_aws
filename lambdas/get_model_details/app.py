import json
import os

import boto3

PRIMARY_KEY = os.environ['PRIMARY_KEY']
TABLE_NAME = os.environ["TABLE_NAME"]


def lambda_handler(event, context):

    query_string_parameters = event["queryStringParameters"]
    if query_string_parameters is None:
        return {
            "statusCode": 500,
            "body": f"Query String Parameters are not passed. The '{PRIMARY_KEY}' parameter is required"
        }

    try:
        dynamodb = boto3.client('dynamodb')
        response = dynamodb.get_item(
            TableName=TABLE_NAME,
            Key={
                'model_name': {
                    'S': query_string_parameters[PRIMARY_KEY]
                }
            }
        )

    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Internal Error. The following error message is caught: {e} <<"
        }

    if "Item" not in response:
        response = f"Item '{query_string_parameters[PRIMARY_KEY]}' not found in the table" \
                   f" '{TABLE_NAME}'"
        return {
            'statusCode': 200,
            'body': response
        }

    return {
        "statusCode": 200,
        "body": json.dumps(response["Item"])
    }

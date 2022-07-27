import json
import os

import boto3


def lambda_handler(event, context):

    query_string_parameters = event["queryStringParameters"]
    if query_string_parameters is None:
        return {
            "statusCode": 500,
            "body": f"Query String Parameters are not passed. The '{os.environ['primary_key']}' parameter is required"
        }

    try:
        dynamodb = boto3.client('dynamodb')
        response = dynamodb.get_item(
            TableName=os.environ["table_name"],
            Key={
                'model_name': {
                    'S': query_string_parameters[os.environ['primary_key']]
                }
            }
        )

    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Internal Error. The following error message is caught: {e} <<"
        }

    if "Item" not in response:
        response = f"Item '{query_string_parameters[os.environ['primary_key']]}' not found in the table" \
                   f" '{os.environ['table_name']}'"
        return {
            'statusCode': 200,
            'body': response
        }

    return {
        "statusCode": 200,
        "body": json.dumps(response["Item"])
    }

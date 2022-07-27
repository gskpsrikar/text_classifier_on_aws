import json
import boto3


def lambda_handler(event, context):

    query_string_parameters = event["queryStringParameters"]
    if query_string_parameters is None:
        return {
            "statusCode": 500,
            "body": f"Query String Parameters are not passed. The 'model_name' parameter is required"
        }

    try:
        db = boto3.client('dynamodb')
        tables = db.list_tables()['TableNames']
        print(tables)
        message = {
            "NumberOfTables": len(tables),
            "tables": tables
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Internal Error. The following error message is caught: {e} <<"
        }

    return {
        "statusCode": 200,
        "body": json.dumps(message)
    }

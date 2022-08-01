import os
import json
import boto3


def lambda_handler(event, context):
    client = boto3.client("ecs")
    try:
        response = client.run_task(
            cluster=os.environ['CLUSTER'],
            group=os.environ['GROUP'],
            launchType='FARGATE',
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': [os.environ['SUBNETS']],
                    'securityGroups': [os.environ['SECURITY_GROUPS']]
                }
            },
            taskDefinition=os.environ['TASK_DEFINITION']
        )

        return {
            "statusCode": 200,
            "body": json.dumps(f"Work in progress - Task Arn: {response['tasks'][0]['taskArn']}")
        }
    except Exception as e:
        return {
            "statusCode": 200,
            "body": json.dumps(f"ECS Run Task failed due to the following error: {e}")
        }

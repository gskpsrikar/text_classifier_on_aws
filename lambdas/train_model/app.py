import os
import json
import boto3

MODEL_NAME = os.environ['MODEL_NAME']
CLUSTER = os.environ['CLUSTER']
GROUP = os.environ['GROUP']
SUBNET = os.environ['SUBNETS']
SECURITY_GROUP = os.environ['SECURITY_GROUPS']
TASK_DEFINITION = os.environ['TASK_DEFINITION']


def check_model_name_in_db() -> bool:
    """
    Check if MODEL_NAME is already in the database or not. Returns True if MODEL_NAME already exists.
    :return: True or False
    """
    pass


def create_s3_folder_for_artifact_storage() -> str:
    """
    Create a dedicated folder (prefix) in S3 to store all the artifacts related to the model.
    :return: s3 prefix
    """
    client = boto3.client("s3")
    pass


def run_task() -> dict:
    """
    Run a new task using for the ECS Task Definition TASK_DEFINITION
    :return:
    """
    client = boto3.client("ecs")
    try:
        response = client.run_task(
            cluster=CLUSTER,
            group=GROUP,
            launchType='FARGATE',
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': [SUBNET],
                    'securityGroups': [SECURITY_GROUP]
                }
            },
            taskDefinition=TASK_DEFINITION
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


def lambda_handler(event, context) -> dict:
    if not check_model_name_in_db():
        return {
            "statusCode": 500,
            "body": json.dumps(f"Model name {MODEL_NAME} is taken. Please choose a unique name.")
        }

    return run_task()

import boto3


def lambda_handler(event, context):

    email = event["queryStringParameters"]["email"]

    client_ses = boto3.client('ses')

    response = client_ses.list_identities(
        IdentityType="EmailAddress",
        MaxItems=10
    )

    if email not in response['Identities']:
        return {
            'statusCode': 200,
            'body': f"User with email {email} not found. Use the POST method and finish the verification."
        }
    else:
        response = client_ses.list_verified_email_addresses()
        if email not in response['VerifiedEmailAddresses']:
            user_status = "NOT VERIFIED"
        else:
            user_status = "VERIFIED"
        return {
            'statusCode': 200,
            'body': f"User with email {email} is found. The user is {user_status}"
        }

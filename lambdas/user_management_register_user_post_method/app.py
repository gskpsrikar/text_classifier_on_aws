import os

import boto3

MAXIMUM_USER_COUNT = int(os.environ["MAXIMUM_USER_COUNT"])

client_ses = boto3.client('ses')


def check_identity_count_and_existing_identities(email_address):
    response = client_ses.list_identities(
        IdentityType="EmailAddress",
        MaxItems=100
    )

    return {
        'count' : len(response['Identities']),
        'exists' : email_address in response['Identities']
    }


def check_email_string_format(email_address):
    email_address = email_address.split("@")
    assert len(email_address) == 2


def lambda_handler(event, context):

    email_address = event

    # Check user count
    checks = check_identity_count_and_existing_identities(email_address=email_address)
    if checks['count'] >= MAXIMUM_USER_COUNT:
        return {
            'statusCode': 500,
            'body': 'User limit exceeded. Cannot register new user.'
        }
    elif checks['exists']:
        return {
            'statusCode': 500,
            'body': 'Email address already registered. Please try another email or de-register the email.'
        }

    # Check email string validity
    try:
        check_email_string_format(email_address=email_address)
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Invalid email. Process exited. Email should be of the format 'user@domain'"
        }

    response = client_ses.verify_email_identity(EmailAddress=email_address)

    print(response)

    return {
        'statusCode': 200,
        'body': f"Verification for the email {email_address} raised. "
                f"To finish verification, check your email inbox and click on the link."
    }

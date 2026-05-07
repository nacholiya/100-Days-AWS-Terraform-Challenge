def lambda_handler(event, context):
    print("Message received from SQS")
    print(event)

    return {
        "statusCode": 200
    }
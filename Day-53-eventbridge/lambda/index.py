def lambda_handler(event, context):
    print("EventBridge triggered the Lambda function!")
    print("Received event:", event)

    return {
        "statusCode": 200,
        "body": "Lambda executed successfully"
    }
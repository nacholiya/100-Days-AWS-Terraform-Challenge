def lambda_handler(event, context):

    print("Step 2 executed")

    return {
        "statusCode": 200,
        "message": "Step 2 completed"
    }
def lambda_handler(event, context):

    print("Step 1 executed")

    return {
        "statusCode": 200,
        "message": "Step 1 completed"
    }
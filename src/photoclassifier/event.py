import base64

def on_event(event, context):
    print(f"Function triggered by messageId {context.event_id} published at {context.timestamp}")
    data = base64.b64decode(event['data']).decode('utf-8')
    print(f"Data: {data}")

    return f"Processed message with ID: {context.event_id}"


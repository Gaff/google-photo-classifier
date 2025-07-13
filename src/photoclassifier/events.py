import base64
import json
from google.cloud import storage, vision

def on_event(event, context):
    print(f"Function triggered by messageId {context.event_id} published at {context.timestamp}")

    payload = base64.b64decode(event['data']).decode('utf-8')
    attributes = json.loads(payload)

    bucket_name = attributes.get('bucket')
    file_name = attributes.get('name')

    # Get the image from Cloud Storage
    image_uri = f'gs://{bucket_name}/{file_name}'
    image = vision.Image()
    image.source.image_uri = image_uri

    # Perform safe search detection
    vision_client = vision.ImageAnnotatorClient()
    response = vision_client.safe_search_detection(image=image)
    safe_search = response.safe_search_annotation
    if response.error.message:
        raise Exception(f'Vision API error: {response.error.message}')

    is_adult = (
        safe_search.adult in [vision.Likelihood.LIKELY, vision.Likelihood.VERY_LIKELY]
        or safe_search.violence in [vision.Likelihood.LIKELY, vision.Likelihood.VERY_LIKELY]
    )

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    metadata = blob.metadata or {}
    label = 'adult' if is_adult else 'safe'
    metadata['content-rating'] = label

    print(f"Labeled file '{file_name}' as '{label}'.")
    return f"Processed message with ID: {context.event_id}"


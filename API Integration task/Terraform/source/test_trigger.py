import requests
import json

# Define the endpoint URL
url = 'API endpoint'

# Define the JSON payload
payload = {
    "body": {
        "incident": {
            "id": "123456",
            "summary": "Test Incident",
            "html_url": "https://www.pagerduty.com/"
        }
    }
}

# Set the headers and encode the payload as JSON
headers = {'Content-Type': 'application/json'}
payload_str = json.dumps(payload)

# Send the request and print the response
response = requests.post(url, headers=headers, data=payload_str)

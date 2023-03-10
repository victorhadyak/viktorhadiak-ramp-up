import requests
from requests.auth import HTTPBasicAuth
import json
import os

jira_url = os.environ['JIRA_URL']
jira_user = os.environ['JIRA_USER']
jira_token = os.environ['JIRA_TOKEN']
jira_key = os.environ['JIRA_KEY']
jira_issue = os.environ['JIRA_ISSUE']
jira_id = os.environ['JIRA_ID']
webex_token = os.environ['WEBEX_ACCESS_TOKEN'] 
webex_space_id = os.environ['WEBEX_SPACE_ID']

# Lambda body
def lambda_handler(event, context):
    # Parse the PagerDuty
    pd_payload_str = json.dumps(event['body'])
    pd_payload = json.loads(pd_payload_str)
    incident_id = pd_payload['incident']['id']
    incident_summary = pd_payload['incident']['summary']
    incident_url = pd_payload['incident']['html_url']  
      
    # Create a new Jira ticket  
    auth = HTTPBasicAuth(jira_user, jira_token)
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    jira_payload = json.dumps( {
      "fields": {      
        "issuetype": {
          "name": jira_issue
        },
        "labels": [
          incident_id,
          incident_url
        ],   
        "project": {
          "id": jira_id
        },
        "summary": incident_summary,
      },
      "update": {}
    } )    
    response = requests.request(
   	"POST",
   	f'{jira_url}/rest/api/3/issue',
   	auth=auth,
   	data=jira_payload,
   	headers=headers      	  	
    )
    response.raise_for_status()
    jira_ticket_url = f'{jira_url}/jira/core/projects/{jira_key}/issues' 
    incident_message = jira_ticket_url 

     #Send a message to a Webex 
    url = "https://webexapis.com/v1/messages" 
    headers = {
    "Authorization": webex_token,  
    "Content-Type": "application/json"
    }
    payload = {
    "roomId": webex_space_id,
    "text": incident_message
    }
    response = requests.post(url, data=json.dumps(payload), headers=headers)

Lambda function that automate the process of creating Jira tickets.

-PagerDuty sends a webhook payload to the Lambda function, which parses the payload to extract the incident ID and summary.

-The function then uses the Jira REST API to create a new Jira ticket, with the incident summary as the ticket summary, and the incident URL as the ticket description.

-Once the Jira ticket is created, the function uses the Webex Teams REST API to send a message to a specified Webex Teams space, notifying of the new ticket and providing a link to the Jira ticket.
![Lambda](https://user-images.githubusercontent.com/109483154/224041505-8dd943f3-8e70-49de-aeb4-0af5e446b991.jpeg)
AWS CLI command for providing environment variables to Lambda -
aws lambda update-function-configuration \
  --function-name pd-jira-webex-lambda \
  --environment Variables="{WEBEX_ACCESS_TOKEN=, WEBEX_SPACE_ID=, JIRA_TOKEN=, JIRA_USER=, JIRA_URL=, JIRA_KEY=, JIRA_ISSUE=, JIRA_ID=}"

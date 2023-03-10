jira_webex_lambda_function.zip contains lambda_function.py and the 'requests' library which is not included in the AWS Lambda Python runtime environment by default. 

AWS CLI command for providing environment variables to Lambda -
aws lambda update-function-configuration \
  --function-name pd-jira-webex-lambda \
  --environment Variables="{WEBEX_ACCESS_TOKEN=, WEBEX_SPACE_ID=, JIRA_TOKEN=, JIRA_USER=, JIRA_URL=, JIRA_KEY=, JIRA_ISSUE=, JIRA_ID=}"
  

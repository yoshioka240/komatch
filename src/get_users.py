import requests
import json
import boto3

def lambda_handler(event, context):
    url = 'https://slack.com/api/users.list'
    token = 'xoxb-1269020941138-1275956616086-by0xpVS1BQvINqiTCGHlWqyI'

    # ユーザー情報を取得
    payload = {'token': token}
    response = requests.get(url,params=payload)
    members_info = response.json()['members']

    # DynamoDBに登録
    table_name = 'DevKomatch'
    dynamo = boto3.client('dynamodb')
    for _ in range(len(members_info)):
        item1 = {
            'id': {'S': members_info[_]['id']},
            'data_type': {'S': 'Name'},
            'data_value': {'S': members_info[_]['name']}
        }
        item2 = {
            'id': {'S': members_info[_]['id']},
            'data_type': {'S': 'WorkspaceID'},
            'data_value': {'S': members_info[_]['team_id']}
        }
        dynamo.put_item(TableName=table_name, Item=item1)
        dynamo.put_item(TableName=table_name, Item=item2)

    return 0

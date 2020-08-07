# command to deploy
`sam deploy --region ap-northeast-1 --stack-name komatch-dev --capabilities CAPABILITY_NAMED_IAM --s3-bucket komatch-s3-20200807`

# command to dynamodb deploy
`aws cloudformation deploy --template-file komatch_dynamodb.yml --stack-name komatch-dynamodb`

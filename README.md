# ディレクトリ構成
- `script` ...デプロイコマンドを記述したファイルを配置
- `src` ...Lambda実行関数ファイルを配置
- `templates` ...CloudFormation, SAM 実行ymlを配置
- `test` ...Lambda実行関数のテストコードファイルを配置

# デプロイコマンド
## dev
### S3
`sh script/deploy_dev-komatch-s3`
### DynamoDB
`sh script/deploy_dev-komatch-dynamodb`
### SAM
`sh script/deploy_dev-komatch-sam`

## dev1, dev2, dev3
### S3
`sh script/deploy_dev${i}-komatch-s3`
### DynamoDB
`sh script/deploy_dev${i}-komatch-dynamodb`
### SAM
`sh script/deploy_dev${i}-komatch-sam`

## prod
### S3
`sh script/deploy_prod-komatch-s3`
### DynamoDB
`sh script/deploy_prod-komatch-dynamodb`
### SAM
`sh script/deploy_prod-komatch-sam`

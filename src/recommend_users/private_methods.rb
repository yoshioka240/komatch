private

def table_name
  @table_name ||= ENV['DDB_TABLE']
end

# NOTE: DynamoDBのクラスメソッド的なものにできたらいいなあ
def dynamodb_find_by(key, data_type)
  dynamodb.get_item(table_name: table_name, key: { id: key, data_type: data_type }).item&.dig('data_value')
end

def check_not_sent_user_ids(question_id)
  # 質問したユーザの取得: 本来は以下のようにかけるが、データがないのでstubする
  user_id = dynamodb_find_by(question_id, 'UserId')
  workspace = dynamodb_find_by(user_id, 'WorkspaceID')

  all_user_ids = user_ids_in_workspace(workspace)
  sent_user_ids_json = dynamodb_find_by(question_id, 'SentUserIds')
  sent_user_ids = sent_user_ids_json ? JSON.parse(dynamodb_find_by(question_id, 'SentUserIds')) : nil

  not_sent_user_ids = all_user_ids.reject { |u_id| u_id == user_id || sent_user_ids&.include?(u_id) }
  now_send_user_ids = choice_user_ids(not_sent_user_ids)
  put_sent_for(question_id, now_send_user_ids, sent_user_ids)

  now_send_user_ids
end

# WorkspaceIDで絞りこんでscan
def user_ids_in_workspace(workspace)
  dynamodb.scan(
    table_name: table_name,
    scan_filter: {
      id: { attribute_value_list: ['U'], comparison_operator: 'BEGINS_WITH' },
      data_type: { attribute_value_list: ['WorkspaceID'], comparison_operator: 'BEGINS_WITH' },
      data_value: { attribute_value_list: [workspace], comparison_operator: 'EQ' }
    }
  ).items.map { |h| h['id'] }
end

def choice_user_ids(user_ids)
  # TODO: ランダムじゃなく選べるようにいつかしたい
  user_ids.sample(USERS_COUNT_SEND_AT_ONCE)
end

def put_sent_for(question_id, user_ids, sent_user_ids)
  sent_user_ids ||= []
  dynamodb.put_item(
    table_name: table_name,
    item: {
      id: question_id,
      data_type: 'SentUserIds',
      data_value: (user_ids + sent_user_ids).compact.to_json
    }
  )
end

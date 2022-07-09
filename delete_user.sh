#!/bin/sh

export user="test-user"

# AccessKeyの削除にはAccessKeyIdの指定が必要。
access_key_id=$(aws iam list-access-keys \
--user-name ${user} --query 'AccessKeyMetadata[0].AccessKeyId' --output text)

# AccessKeyを削除しないとユーザの削除ができない。
aws iam delete-access-key --user-name ${user} --access-key-id ${access_key_id}

# ユーザ削除
aws iam delete-user --user-name ${user}

# s3-iam-test
AWS CLIを使用して、s3のバケットポリシーの動作を確認します。

<br />

## 準備

1. ユーザ作成
    ```
    $ aws iam create-user --user-name test-user
    ```

2. アクセスキー作成
    ```
    # 出力されるAccessKeyとSecretAccessKeyは3で必要です。
    $ aws iam create-access-key --user-name test-user
    ```

3. `profile`の追加
    ```
    # 2で出力されたAccessKeyとSecretAccessKeyをそれぞれ入力
    $ aws configure --profile test
    AWS Access Key ID [None]: XXXXXXX
    AWS Secret Access Key [None]:  XXXXXXX
    Default region name [None]: ap-northeast-1
    Default output format [None]: json
    ```

<br />

## s3で実験

1. s3の準備(権限があるprofileで実行してください)
    ```
    # s3とオブジェクトの作成(ハイフンは標準出力)
    $ export bucket=xxxxx
    $ aws s3 mb s3://${bucket}
    $ echo foo | aws s3 cp - s3://${bucket}/foo.txt

    # 確認
    $ aws s3 cp s3://${bucket}/foo.txt - | cat
    $ aws s3 ls s3://${bucket}
    ```

2. 作成したユーザには権限がない。
    ```
    $ aws s3 ls s3://${bucket} --profile test
    An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied
    ```

3. s3のバケットポリシーを変更
    ```
    # 実行前に`bucket_policy.json`のResourceのARNにバケット名を追記してください。
    $ aws s3api put-bucket-policy --bucket ${bucket} --policy file://bucket_policy.json
    ```

4. 3で権限を付与したのでアクセス可能
    ```
    $ aws s3 ls s3://${bucket} --profile test
    ```

<br />

## 後片付け

1. s3
    ```
    $ aws s3 rb s3://${bucket} --force  
    ```

2. IAMユーザ
    ```
    $ sh delete_user.sh

    # 手動でprofile情報を消してください。
    $ vi ~/.aws/credentials
    $ vi ~/.aws/credentials
    ```

## 参考
- [S3バケットポリシーの具体例で学ぶAWSのPolicyドキュメント](https://dev.classmethod.jp/articles/learn-aws-policy-documents-with-examples/)

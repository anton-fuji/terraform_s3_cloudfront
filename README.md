# terraform_s3_cloudfront
## 構成イメージ
![](img/architecture-diagram.png)



## Set up Terraform on CloudShell
```sh
# Terraform v1.11.4 をダウンロード
wget https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip

# 解凍して /usr/local/bin に配置
sudo unzip terraform_1.11.4_linux_amd64.zip -d /usr/local/bin/

# バージョン確認
terraform --version  # Terraform v1.11.4
```

## Shell Script Permissions
**実行権限を付与してからスクリプトを使ってください**

```sh
chmod +x ./script/deploy.sh
chmod +x ./script/destory.sh
```

## スクリプト実行前にvariablesの追加
**`infra/terraform.tfvars` ファイルを作成後、以下の値を入力してください。**
```
aws_region     = "ap-northeast-1"            
acm_region     = "us-east-1"                 
domain_name    = "fuuji.site"               
hosted_zone_id = "<your-hosted-zone-id>"         
bucket_name    = "fuji-portfolio-bucket-s3"
```

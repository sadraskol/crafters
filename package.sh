#! /bin/bash

pushd front/
npm test
NODE_ENV=production npm run webpack
popd
MIX_ENV=prod mix phx.digest

MIX_ENV=prod mix compile
MIX_ENV=prod mix release

# From https://gist.github.com/chrismdp/6c6b6c825b07f680e710

# Env: S3KEY
# Env: S3SECRET

function put_s3() {
  local path=$1
  local file=$2
  local aws_path=$3
  local bucket='rel-crafters'
  local date=$(date +"%a, %d %b %Y %T %z")
  local acl="x-amz-acl:public-read"
  local content_type='application/x-compressed-tar'
  local string="PUT\\n\\n$content_type\\n$date\\n$acl\\n/$bucket$aws_path$file"
  local signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}

# $release = "_build/hello/hello.tar.gz"
# put_s3 $(dirname "$release") $(basename "$release") "/path/on/s3/to/files/"

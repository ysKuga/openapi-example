#!/usr/bin/env sh

# 当ファイルのディレクトリのパス
SCRIPTS_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
# OpenAPI 用ディレクトリ
OPENAPI_DIR=$(dirname $SCRIPTS_DIR)/../openapi

# 生成タイプ (いったん固定)
TYPE="typescript-axios"
# 第一引数 : コード生成対象
TARGET=$1
# 第二引数 : 出力先
OUTPUT=$2

# コード生成対象ディレクトリ
TARGET_DIR=$OPENAPI_DIR/$TARGET

# 対象が指定されていない場合
if [ -z "$TARGET" ]; then
  echo "第一引数にコード生成対象を指定してください。"
  ls $OPENAPI_DIR | grep -v -e ".*\..*$"
  exit 1
fi

# 出力先が指定されていない場合
if [ -z "$OUTPUT" ]; then
  echo "第二引数に出力先を指定してください。"
  exit 1
fi

# Docker チェック
DOCKER_EXISTS=$(command -v docker)
if [ ! -n "$DOCKER_EXISTS" ]; then
  echo "Docker をインストールしてください。"
  echo "[https://docs.docker.com/engine/install/]"
  exit 1
fi

# $OUTPUT のパス自体が存在していない場合 root ユーザーで生成されるため先行して確定しておく
mkdir -p $OUTPUT

# コード生成
docker run --rm \
  -u $(stat -c "%u:%g" .) \
  -v $TARGET_DIR:/input \
  -v $OUTPUT:/output \
  openapitools/openapi-generator-cli \
  generate \
  -g $TYPE \
  -i /input/openapi.yaml \
  -o /output/generated/ \
  --additional-properties \
  useSingleRequestParameter=true

# 統合 openapi.yaml と同一ディレクトリに生成するが、 README の記述が競合するのでさきに実施する
# openapi.json
docker run --rm \
  -u $(stat -c "%u:%g" .) \
  -v $TARGET_DIR:/input \
  -v $OUTPUT:/output \
  openapitools/openapi-generator-cli \
  generate \
  -g openapi \
  -i /input/openapi.yaml \
  -o /output/generated/ \
  --additional-properties \
  useSingleRequestParameter=true

# 統合 openapi.yaml
docker run --rm \
  -u $(stat -c "%u:%g" .) \
  -v $TARGET_DIR:/input \
  -v $OUTPUT:/output \
  openapitools/openapi-generator-cli \
  generate \
  -g openapi-yaml \
  -i /input/openapi.yaml \
  -o /output/generated/ \
  --additional-properties \
  useSingleRequestParameter=true

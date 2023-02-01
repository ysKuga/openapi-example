# openapi-example

OpenAPI を使用するにあたっての実際のコードなど

[ベースの gist](https://gist.github.com/ysKuga/9664fd61cd2315af8fe8dbddbff371c4)

## 構成

以下の記事を参考に `openapi/basic/` を構成

<https://tech.buysell-technologies.com/entry/2021/09/21/095238>

### `tags`

`tags` の指定によりその数だけ `～Api` が生成されるため、特に理由がなければ統一する。

```yaml
get:
  tags:
    - basic
```

### `paths/`

`openapi.yaml` にて `paths` プロパティのパスに `$ref` を指定

```yaml
paths:
  /product/{id}:
    $ref: ./paths/product-[id].yaml
```

- パス内クエリについては `[{変数名}]` の形式とし、スラッシュをハイフンに (とりあえず)
  - `/product/{id}` -> `paths/product-[id].yaml`

### `schemas/`

`openapitools/openapi-generator-cli` による型生成の都合により以下のようにする。

- ケバブケースでファイルを定義
  - ファイル名がパスカルケースに変換されて型が生成されるため

## 課題

### `paths/` 配下でのエラー表示

`paths/` 配下にて以下のような記述をした際にエラー表示が出てしまう。

```yaml
get:
  tags:
    - basic
```

現状エラー解消を行う方法が見つけられていない。

```log
Property tags is not allowed.yaml-schema: https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/schemas/v3.0/schema.json
```

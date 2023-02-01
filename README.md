# openapi-example

OpenAPI を使用するにあたっての実際のコードなど

[ベースの gist](https://gist.github.com/ysKuga/9664fd61cd2315af8fe8dbddbff371c4)

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

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
  - ただし以降に記述するような注意が必要となる。

#### `paths/` 配下のファイル名について

`paths/` 配下で `schemas` プロパティをファイルにより指定する場合、\
その型定義はファイル名に準じたものとなる。

```yaml
# paths/product-[id].yaml
get:
  responses:
    200:
        application/json:
          schema:
            # この指定であると `api.ts` に生成される型名は `ProductId` となる。 (期待される型名は `Product`)
            $ref: ../schemas/product.yaml
```

上記では `生成される型名は` と記述しているが、正確には型は生成されない上に実装に `ProductId` が使用されてしまう。

```ts
// ProductId の型は存在せず any となる。
export const BasicApiFactory = function (configuration?: Configuration, basePath?: string, axios?: AxiosInstance) {
  getProductById(id: number, options?: any): AxiosPromise<ProductId> {
```

このため `schemas/` 配下の読み込みは `components` プロパティを経由させて型名を明示的にしたほうがよい。

```yaml
# paths/product-[id].yaml
get:
  responses:
    200:
        application/json:
          schema:
            $ref: "#/components/schemas/product"
components:
  schemas:
    product:
      $ref: ../schemas/product.yaml
```

- 上記についても独特な挙動があるようで、 `product:` でなく `entity:` としても型名は `Entity` でなく `Product` となる。
  - `schemas:` に直接ファイル名を指定する場合にはファイル名の `-[id]` までを考慮されるが、\
    `components:` 配下の定義の場合には別の挙動がある模様

### `schemas/`

`openapitools/openapi-generator-cli` による型生成の都合により以下のようにする。

- ケバブケースでファイルを定義
  - ファイル名がパスカルケースに変換されて型が生成されるため

## コード生成

### コード生成のオプションについて

生成ファイルの権限を実行ユーザーにする。

```sh
-u $(stat -c "%u:%g" .)
```

`useSingleRequestParameter=true` を指定することにより引数をペイロード形式に

```sh
--additional-properties \
useSingleRequestParameter=true
```

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

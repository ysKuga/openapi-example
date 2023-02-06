/* eslint-disable */
/** 製品 */
export type Product = {
  /** 製品の ID */
  id: number
  /** 製品名 */
  name?: string | undefined
  /** 限定販売かどうか */
  is_limited?: boolean | undefined
  /** 発売日 */
  released_at?: string | undefined
}

/** テスト製品 */
export type Product_test = {
  /** テスト製品の ID */
  id: number
  /** 製品名 */
  name: string
  /** タイプ */
  type?: string | undefined
  /** 限定販売かどうか */
  is_limited?: boolean | undefined
  /** 発売日 */
  released_at?: string | undefined
}

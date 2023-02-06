import type { AspidaClient, BasicHeaders } from 'aspida'
import type { Methods as Methods0 } from './product/_id@number'
import type { Methods as Methods1 } from './product-test/_id@number'

const api = <T>({ baseURL, fetch }: AspidaClient<T>) => {
  const prefix = (baseURL === undefined ? '{server}' : baseURL).replace(/\/$/, '')
  const PATH0 = '/product'
  const PATH1 = '/product-test'
  const GET = 'GET'

  return {
    product: {
      _id: (val1: number) => {
        const prefix1 = `${PATH0}/${val1}`

        return {
          /**
           * 製品を 1 件返す
           * @returns 成功時
           */
          get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods0['get']['resBody'], BasicHeaders, Methods0['get']['status']>(prefix, prefix1, GET, option).json(),
          /**
           * 製品を 1 件返す
           * @returns 成功時
           */
          $get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods0['get']['resBody'], BasicHeaders, Methods0['get']['status']>(prefix, prefix1, GET, option).json().then(r => r.body),
          $path: () => `${prefix}${prefix1}`
        }
      }
    },
    product_test: {
      _id: (val1: number) => {
        const prefix1 = `${PATH1}/${val1}`

        return {
          /**
           * 製品を 1 件返す
           * @returns 成功時
           */
          get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods1['get']['resBody'], BasicHeaders, Methods1['get']['status']>(prefix, prefix1, GET, option).json(),
          /**
           * 製品を 1 件返す
           * @returns 成功時
           */
          $get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods1['get']['resBody'], BasicHeaders, Methods1['get']['status']>(prefix, prefix1, GET, option).json().then(r => r.body),
          $path: () => `${prefix}${prefix1}`
        }
      }
    }
  }
}

export type ApiInstance = ReturnType<typeof api>
export default api

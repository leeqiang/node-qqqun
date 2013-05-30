# QQ qun
# 签名模块
# Author: Lee
# Date: 2013 - 5 - 29
# Email: qiang@teambition.com

crypto = require 'crypto'

Signature = module.exports

Signature.makeSig = (method, apiUrl, params, secret, isVerifyPay) ->
  # 签名函数

  source = makeSource(method, apiUrl, params, isVerifyPay)
  secret = "#{secret}&"
  return crypto
    .createHmac('sha1', secret)
    .update(source)
    .digest('base64')


Signature.urlencode = (params, isVerifyPay) ->
  # 编码参数

  source = []
  for key, val of params
    val = payRepValue(val) if isVerifyPay
    source.push("#{key}=#{val}")
  return source.join('&')


makeSource = (method, apiUrl, params) ->
  # 构造源数据

  method = method.toUpperCase()
  apiUrl = encodeURIComponent(apiUrl)

  params = sort(params)
  params = Signature.urlencode(params)
  source = encodeURIComponent(params)

  return "#{method}&#{apiUrl}&#{source}"


sort = (params) ->
  # 对params通过字母进行排序

  keys = []

  for key, val of params
    keys.push(key)

  keys.sort()

  result = {}
  for key in keys
    result[key] = params[key]
  return result


payRepValue = (src) ->
  # 将排序后的参数(key=value)用&拼接起来，
  # 并进行URL编码”之前，需对value先进行一次编码
  #（编码规则为：除了 0~9 a~z A~Z !*() 之外其他字
  # 符按其ASCII码的十六进制加%进行表示，例如“-”编码为“%2D”）

  src = src.toString()

  dst = ''
  for it in src

    if it.match(/[0-9a-zA-Z!*()]/)
      dst += it
    else
      dst += '%' + it.charCodeAt(0).toString(16).toUpperCase()

  return dst
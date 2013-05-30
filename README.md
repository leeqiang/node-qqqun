nodejs-sdk-v3
=============

##腾讯开放API V3 CoffeeScript - SDK

##文件结构
 - signature.coffee
    - makeSig (method, apiUrl, params, secret, isVerifyPay)
      - method: get || post
      - apiUrl: api地址
      - params: 请求参数
      - secret: app key
      - isVerifyPay: 是否为发货验证签名
    - urlencode (params, isVerifyPay)
      类似python urlencode
      若isVerifyPay为true, 则params里面的参数值会经过payRepValue编码
 - network.coffee http协议发送包
    - open(method, apiPath, params, protocol, callback)
 - api.coffee 调用接口
    - call(urlPath, params, method, protocol, next)
 - stat.coffee 上报数据
    - statReport(statUrl, startTime, params)

如有问题，可邮件我:lee@susworld.com.

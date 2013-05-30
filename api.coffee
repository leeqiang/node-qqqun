# OpenAPI V3 API
# Author: Lee
# Date: 2013 - 5 - 30
# Email: qiang@teambition.com


Sign = require('./signature')
Network = require('./network')
Stat = require('./stat')

OPEN_HTTP_TRANSLATE_ERROR = 1801

class OpenAPIV3

  _appId = 0
  _appKey = ''
  _api = null
  _statUrl = "apistat.tencentyun.com"
  _statApi = null
  _isStat = false

  constructor: (@appId, @appKey, @serverIp) ->
    @_appId = @appId
    @_appKey = @appKey

    @_api = new Network(@_appKey, @serverIp)
    @_statApi = new Stat()

  call: (urlPath, params, method, protocol, next) ->
    # 调用接口，并将数据格式转化成json
    # 只需要传入pf, openid, openkey等参数即可，不需要传入sig

    params.appid = @_appId
    params.format = 'json'

    startTime = @_statApi.getTime()
    try
      @_api.open(method, urlPath, params, protocol, (data)->
        data = JSON.parse(data)
        if @_isStat is true
          statParams = {}
          statParams.appid = params.appid
          statParams.pf = params.pf
          statParams.svr_name = [@serverIp]
          statParams.interface = urlPath
          statParams.protocol = protocol
          statParams.method = method

          if data.hasOwnProperty('ret')
            statParams.rc = data.ret
          else statParams.rc = '-123456'

          @_statApi.statReport(@_statUrl, startTime, statParams)
        return next(JSON.parse(data))
      )
    catch error
      return {'ret': OPEN_HTTP_TRANSLATE_ERROR, 'msg': error }

  verifyPayCallbackSig: (method, urlPath, params) ->
    # 验证回调发货的签名. True or False

    # verifyPay sig
    sig = Sign.makeSig(method, urlPath, params, @_appKey, true)
    return params?.sig is sig

module.exports = OpenAPIV3
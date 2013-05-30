# QQ qun
# stat 模块
# Author: Lee
# Date: 2013 - 5 - 29
# Email: qiang@teambition.com

dgram = require('dgram')
dns = require('dns')

class Stat

  getTime: ->
    # 取当前的ms时间
    return Date.now()


  statReport: (statUrl, startTime, params) ->
    #上报数据

    endTime = @getTime()

    params.time = endTime - startTime
    params.timestamp = @getTime()
    params.collect_point = "sdk-nodejs-v3"

    params = JSON.stringify(params)

    @resolve(statUrl, (hostIp) ->
      if hostIp isnt statUrl
        client = dgram.createSocket('udp4')
        client.send(params, 0, params.length, 80, hostIp)
        client.close()
    )


  resolve: (domain, next) ->
    # 通过域名获取对应IP

    dns.resolve4(domain, (err, addresses) ->
      throw err if err
      next(addresses[0])
    )

module.exports = Stat
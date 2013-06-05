(function() {
  var Stat, dgram, dns;

  dgram = require('dgram');

  dns = require('dns');

  Stat = (function() {
    function Stat() {}

    Stat.prototype.getTime = function() {
      return Date.now();
    };

    Stat.prototype.statReport = function(statUrl, startTime, params) {
      var endTime;

      endTime = this.getTime();
      params.time = endTime - startTime;
      params.timestamp = this.getTime();
      params.collect_point = "sdk-nodejs-v3";
      params = JSON.stringify(params);
      return this.resolve(statUrl, function(hostIp) {
        var client;

        if (hostIp !== statUrl) {
          client = dgram.createSocket('udp4');
          client.send(params, 0, params.length, 80, hostIp);
          return client.close();
        }
      });
    };

    Stat.prototype.resolve = function(domain, next) {
      return dns.resolve4(domain, function(err, addresses) {
        if (err) {
          throw err;
        }
        return next(addresses[0]);
      });
    };

    return Stat;

  })();

  module.exports = Stat;

}).call(this);

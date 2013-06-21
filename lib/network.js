(function() {
  var Network, Sign, http, https, querystring,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  http = require('http');

  https = require('https');

  querystring = require('querystring');

  Sign = require('./signature');

  Network = (function() {
    Network.prototype.serverIp = '119.147.19.43';

    Network.prototype.secret = '';

    Network.prototype.port = 80;

    Network.prototype._requestFunc = http;

    Network.prototype.sigName = 'sig';

    function Network(secret, serverIp, sigName) {
      this.secret = secret;
      this.serverIp = serverIp;
      if (sigName) {
        this.sigName = sigName;
      }
    }

    Network.prototype._makeSendData = function(method, apiPath, params) {
      var sig;

      sig = Sign.makeSig(method, apiPath, params, this.secret);
      params[this.sigName] = encodeURIComponent(sig);
      return Sign.urlencode(params);
    };

    Network.prototype._send = function(apiPath, params, method, protocol, next) {
      var httpOptions, infos, request,
        _this = this;

      protocol = protocol.toLowerCase();
      method = method.toLowerCase();
      if (method !== 'post' && method !== 'get') {
        throw new TypeError('method invalid: ' + method);
      }
      if (__indexOf.call(this.serverIp, ':') >= 0) {
        infos = this.serverIp.split(':');
        this.serverIp = infos[0];
        this.port = infos[1];
      }
      httpOptions = {
        host: this.serverIp,
        method: method.toUpperCase(),
        path: apiPath,
        port: this.port
      };
      if (protocol === 'https') {
        httpOptions.port = 443;
        this._requestFunc = https;
      }
      
      httpOptions.headers = {};
      httpOptions.headers['Content-Length'] = Buffer.byteLength(params);
	if (method === 'post') {
        httpOptions.headers['Content-type'] = 'application/x-www-form-urlencoded';
      } else {
        httpOptions.path += "?" + params;
      }
      request = this._requestFunc.request(httpOptions, function(response) {
        response.setEncoding('utf8');
        return response.on('data', next);
      });
      request.on('error', function(err) {
        console.log('request error: ', err);
      });
      request.on('socket', function(socket) {
        socket.on('error', function(err) {
          if (err){
            console.log("socket error:", err);
            request.abort();
          }
        });
      });
      request.end(params);
    };

    Network.prototype.open = function(apiPath, params, method, protocol, next) {
      if (protocol !== 'http' && protocol !== 'https') {
        throw new TypeError('protocal invalid: ' + protocol);
      }
      params = this._makeSendData(method, apiPath, params);
      return this._send(apiPath, params, method, protocol, next);
    };

    return Network;

  })();

  module.exports = Network;

}).call(this);

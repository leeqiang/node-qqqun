Nodejs-SDK-QQOpenAPIV3
=============

##Tecent API V3 - Nodejs SDK

##Install
```
npm install openapiv3
```

##How To Use
```
var API = require('openapiv3');
var OpenAPI = new API(appId, appKey, serverIp);

OpenAPI.call(apiPath, {}, 'get', 'http', function(result){
    // method and protocol is optional, default 'get', 'http',
    // return object
})
```
##Contact

mailto:lee@susworld.com.

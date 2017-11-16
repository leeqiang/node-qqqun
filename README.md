
Tencent API V3 - Nodejs SDK for QQGroup
===========

## Install
```
npm install qun
```

## How To Use
```
var QunApi = require('qun');
var Qun = new QunApi(appId, appKey, serverIp);

Qun.call(apiPath, {}, 'get', 'http', function(result){
    // method and protocol is optional, default 'get', 'http',
    // return object
})
```

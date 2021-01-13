
/**
 * @fileoverview Example to compose HTTP request
 * and handle the response.
 *
 */

const url = "https://api.mgzf.com/renter-sale/smrt/app/v1/queryElemInfo?roomId=xxxx";
const method = "GET";
const headers = {"Host":"api.mgzf.com","RegId":"xxxxx","Server":"","Cache-Control":"no-cache","User-Agent":"MogoRenter/6.9.2 (iPhone; iOS 14.3; Scale/2.00)","Cookie":"acw_tc=xxxxx","UserId":"xxxxx","Market":"App Store","Channel":"1","AppVersion":"6.9.2","UUID":"xxxxx","X-Tingyun-Id":"xxxxx;c=2;r=631704567","Signature":"xxxx","OS":"iOS","DeviceId":"xxxxx","Connection":"keep-alive","Token":"xxxx","Timestamp":"xxxx","Accept-Language":"en-US;q=1, zh-Hans-US;q=0.9, ja-JP;q=0.8","Model":"iPhone12,8","OSVersion":"14.3","Accept":"*/*","Accept-Encoding":"gzip;q=1.0, compress;q=0.5","source-type":"1"};
const data = {"info": "abc"};

const myRequest = {
    url: url,
    method: method, // Optional, default GET.
    headers: headers, // Optional.
    body: JSON.stringify(data) // Optional.
};

$task.fetch(myRequest).then(response => {
    // response.statusCode, response.headers, response.body
    console.log(response.body);
    const obj = JSON.parse(response.body);
    console.log(obj.content.elems[0].elemBalanceDesc);
    if (obj.content.elems[0].elemBalance < 20) {
        $notify("蘑菇租房", "房屋剩余电量低", obj.content.elems[0].elemBalanceDesc); // Success!
        $done();
    }
}, reason => {
    // reason.error
    $notify("Title", "Subtitle", reason.error); // Error!
    $done();
});

// 返回字段参考
// {
//     "code":"10000",
//     "message":"success",
//     "detail":null,
//     "content":{
//         "elems":[
//             {
//                 "hwKeyId":146366,
//                 "onlineStatus":1,
//                 "onlineStatusDesc":"网络正常使用中",
//                 "elemStatus":1,
//                 "elemStatusDesc":"电表通电",
//                 "elemBalanceDesc":"剩余电量92.78度",
//                 "elemBalance":92.78,
//                 "showMsg":null,
//                 "updateTimeDesc":"更新时间: 2021-01-13 13:18",
//                 "payMode":1,
//                 "startDate":"2020-11-11",
//                 "endDate":"2021-01-12",
//                 "electricPrice":0.80
//             }
//         ]
//     }
// }

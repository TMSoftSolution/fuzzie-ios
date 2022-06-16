function returnDataToApp(hmac, response) {
    var message = {
        "hmac" : hmac,
        "txnResp" : response
    };
    window.webkit.messageHandlers.onReceivedData.postMessage(message);
}

function returnDataToApp(hmac, response, keyId) {
    var message = {
        "hmac" : hmac,
        "txnResp" : response,
        "KeyId" : keyId
    };
    window.webkit.messageHandlers.onReceivedData.postMessage(message);
}


function returnDataToApp(hmac, response, keyId, stageRespCode, actionCode) {
    var message = {
        "hmac" : hmac,
        "txnResp" : response,
        "KeyId" : keyId,
        "stageRespCode" : stageRespCode,
        "actionCode" : actionCode
    };
    window.webkit.messageHandlers.onReceivedData.postMessage(message);
}

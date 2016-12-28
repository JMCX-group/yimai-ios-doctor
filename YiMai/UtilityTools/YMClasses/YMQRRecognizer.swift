//
//  YMQRRouter.swift
//  YiMai
//
//  Created by superxing on 16/9/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public typealias YMQRCallback = ((qrData: AnyObject) -> Void)

class YMQRRecognizer: NSObject {

    static func RecognizFromQRJson(json: String, qrRecognizedFunc: YMQRCallback, qrUnrecognizedFunc: YMQRCallback? = nil) {
        let jsonDict = YMVar.TryToGetDictFromJsonStringData(json)
        let data = jsonDict!["YMQRData"]

        qrRecognizedFunc(qrData: data!)

//        if(nil != jsonDict) {
//            let data = jsonDict!["YMQRData"]
//            if(nil != data) {
//                qrRecognizedFunc(qrData: data!)
//                return
//            }
//        }
        
        qrUnrecognizedFunc?(qrData: json)
    }
    
    static func GenQRJsonString(data: AnyObject, opt: String = "add_friend") -> String? {
        let qrData = ["data": data, "operation": opt]
        
        if(NSJSONSerialization.isValidJSONObject(qrData)) {
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(qrData, options: NSJSONWritingOptions.PrettyPrinted)
            return String(data: jsonData, encoding: NSUTF8StringEncoding)
        } else {
            return nil
        }
    }
}
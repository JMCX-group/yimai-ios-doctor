//
//  YMNetworkUtility.swift
//  storyboard-try
//
//  Created by why on 16/5/5.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import AFNetworking

public typealias NetworkProgressHandler = ((NSProgress) -> Void)
public typealias NetworkSuccessHandler = ((NSURLSessionDataTask, AnyObject?) -> Void)
public typealias NetworkErrorHandler = ((NSURLSessionDataTask?, NSError) -> Void)


public class YMNetworkRequestConfig {
    public var URL: String = ""
    public var Param: AnyObject? = nil
    public var BodyWidthBlockBuilder: ((AFMultipartFormData) -> Void)? = nil
    public var ProgressHandler: NetworkProgressHandler? = nil
    public var SuccessHandler: NetworkSuccessHandler? = nil
    public var ErrorHandler: NetworkErrorHandler? = nil
}

public class YMNetwork {
    private func BuildImageRequestManager() -> AFHTTPSessionManager {
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFHTTPRequestSerializer()
        let resImageSerializer = AFImageResponseSerializer()

        resImageSerializer.acceptableContentTypes = ["image/jpeg", "image/png"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resImageSerializer
        
        return manager
    }
    
    private func BuildJsonRequestManager() -> AFHTTPSessionManager {
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFHTTPRequestSerializer()
        let resJsonSerializer = AFJSONResponseSerializer()

        resJsonSerializer.acceptableContentTypes = ["application/json"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resJsonSerializer
        
        return manager
    }
    
    public func RequestImageByGet(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let imageManager = self.BuildImageRequestManager()
        
        return imageManager.GET (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func RequestJsonByGet(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let jsonManager = self.BuildJsonRequestManager()
        
        return jsonManager.GET (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }

    public func RequestJsonByPost(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let jsonManager = self.BuildJsonRequestManager()

        return jsonManager.POST (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func UploadJsonByGet() {}
    public func UploadJsonByPost() {}
    
    public func UploadFile() {}

    public func UploadFileWithJsonParam() {}
}





































//
//  YMCoreDataEngine.swift
//  storyboard-try
//
//  Created by why on 16/5/10.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public typealias YMCoreMemDataHandler = (AnyObject?, NSOperationQueue) -> Bool

public class YMCoreMemDataOnceHandler: NSObject {
    public var Handler: YMCoreMemDataHandler
    public var CompletedFlag: Bool = false
    
    init(handler: YMCoreMemDataHandler) {
        self.Handler = handler
    }
}

private class YMCoreData {
    private static var CoreMemData = [String:AnyObject]()
    private static var CoreMemDataHandlerMap = [String:[YMCoreMemDataHandler]]()
    private static var CoreMemDataHandlerOnceMap = [String:[YMCoreMemDataOnceHandler]]()
}

public class YMCoreDataEngine {
    private static var EngineInitialized = false
    private static var MainQueue = NSOperationQueue.mainQueue()
    private static var HandlerQueue = NSOperationQueue()
    private static var OnecHandlerQueue = NSOperationQueue()
    private static var OnecHandlerClearQueue = NSOperationQueue()
    
    private static let OneceHandlerLock = NSObject()
    
    private static var HandlerProcessIntervalInUS: UInt32 = 100000
    private static var OnceHandlerMapClearIntervalInUS: UInt32 = 100000
    
    public static func GetData(key: String) -> AnyObject? {
        return YMCoreData.CoreMemData[key]
    }
    
    public static func SaveData(key: String, data: AnyObject) {
        if(nil == YMCoreData.CoreMemData[key]) {
            YMCoreData.CoreMemData[key] = [AnyObject]()
        }
        YMCoreData.CoreMemData[key] = data
    }
    
    public static func SetDataHandler(module: String, handler: YMCoreMemDataHandler) {
        if(nil == YMCoreData.CoreMemDataHandlerMap[module]) {
            YMCoreData.CoreMemDataHandlerMap[module] = [YMCoreMemDataHandler]()
        }
        
        YMCoreData.CoreMemDataHandlerMap[module]?.append(handler)
    }
    
    public static func SetDataOnceHandler(module: String, handler: YMCoreMemDataOnceHandler) {
        if(nil == YMCoreData.CoreMemDataHandlerOnceMap[module]) {
            YMCoreData.CoreMemDataHandlerOnceMap[module] = [YMCoreMemDataOnceHandler]()
        }
        
        YMCoreData.CoreMemDataHandlerOnceMap[module]?.append(handler)
    }
    
    private static func DataHandlerDispatcher() {
        while (true) {
            usleep(YMCoreDataEngine.HandlerProcessIntervalInUS)
            for (key, handlers) in YMCoreData.CoreMemDataHandlerMap {
                let data = YMCoreData.CoreMemData[key]
                for handler in handlers {
                    handler(data, YMCoreDataEngine.MainQueue)
                }
            }
        }
    }
    
    private static func DataOnceHandlerMapClear() {
        while (true) {
            usleep(YMCoreDataEngine.OnceHandlerMapClearIntervalInUS)

            objc_sync_enter(YMCoreDataEngine.OneceHandlerLock)

            for (key, handlers) in YMCoreData.CoreMemDataHandlerOnceMap {
                var clearFlag = true
                for handler in handlers {
                    if(!handler.CompletedFlag) {
                        clearFlag = false
                        break
                    }
                }
                
                if(0 != handlers.count) {
                    if(clearFlag) {
                        YMCoreData.CoreMemDataHandlerOnceMap[key]?.removeAll()
                    }
                }
            }
            objc_sync_exit(YMCoreDataEngine.OneceHandlerLock)
        }
    }
    
    private static func DataOnceHandlerDispatcher() {
        while (true) {
            usleep(YMCoreDataEngine.HandlerProcessIntervalInUS)
            for (key, handlers) in YMCoreData.CoreMemDataHandlerOnceMap {
                let data = YMCoreData.CoreMemData[key]
                objc_sync_enter(YMCoreDataEngine.OneceHandlerLock)
                for handler in handlers {
                    if(!handler.CompletedFlag) {
                        handler.CompletedFlag = handler.Handler(data, YMCoreDataEngine.MainQueue)
                    }
                }
                objc_sync_exit(YMCoreDataEngine.OneceHandlerLock)
            }
        }
    }
    
    public static func EngineInitialize() {
        if(YMCoreDataEngine.EngineInitialized){return}
        
        YMCoreDataEngine.HandlerQueue.addOperationWithBlock(YMCoreDataEngine.DataHandlerDispatcher)
        YMCoreDataEngine.OnecHandlerQueue.addOperationWithBlock(YMCoreDataEngine.DataOnceHandlerDispatcher)
        YMCoreDataEngine.OnecHandlerClearQueue.addOperationWithBlock(YMCoreDataEngine.DataOnceHandlerMapClear)
        
        YMCoreDataEngine.EngineInitialized = true
    }
}



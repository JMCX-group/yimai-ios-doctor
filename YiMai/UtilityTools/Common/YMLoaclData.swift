//
//  YMLoaclData.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Graph

public class YMLocalData {
    private static let Engine = Graph()
    
    public static func SaveLogin(user: String, pwd: String) {
        let e = Entity(type: YMLocalDataStrings.EN_LOGIN_INFO)
        e[YMCoreDataKeyStrings.KEY_LOGIN_NAME] = user
        e[YMCoreDataKeyStrings.KEY_PASSWORD] = pwd
        YMLocalData.Engine.save()
    }
    
    public static func ClearLogin() {
        let es = YMLocalData.Engine.searchForEntity(types: [YMLocalDataStrings.EN_LOGIN_INFO])
        
        for v in es {
            v.delete()
        }
        
        YMLocalData.Engine.save()
    }
    
    public static func GetLoginInfo() -> Entity? {
        let es = YMLocalData.Engine.searchForEntity(types: [YMLocalDataStrings.EN_LOGIN_INFO])
        if(0 == es.count) {
            return nil
        }
        
        return es[0]
    }
}
















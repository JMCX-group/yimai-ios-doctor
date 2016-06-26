//
//  PageYiMaiDoctorDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageYiMaiDoctorDetailActions: PageJumpActions {
    private var TargetView: PageYiMaiDoctorDetailBodyView? = nil
    private var GetInfoApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        GetInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_DETAIL,
                                  success: GetInfoSuccess, error: GetInfoError)
        
        
        self.TargetView = self.Target as? PageYiMaiDoctorDetailBodyView
    }
    
    public func GetInfoSuccess(data: NSDictionary?) {
        TargetView?.LoadData()
    }
    
    public func GetInfoError(error: NSError) {
        print(error)
    }
    
    public func GetInfo() {
        GetInfoApi?.YMQueryUserInfoById(PageYiMaiDoctorDetailBodyView.DocId)
    }
}
//
//  PageMyPatientListActions.swift
//  YiMai
//
//  Created by superxing on 16/9/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageMyPatientListActions: PageJumpActions {
    var PatientApi: YMAPIUtility!
    var TargetView: PageMyPatientListBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        PatientApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_MY_PATIENT_LIST,
                                  success: GetListSuccess, error: GetListError)
        
        TargetView = Target as! PageMyPatientListBodyView
    }
    
    func GetListSuccess(data: NSDictionary?) {
        
        let realData = data!["data"] as! [String: AnyObject]
        
        TargetView.LoadData(realData)
    }
    
    func GetListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func GetMyPatientList() {
        PatientApi.YMGetMyPatientList()
    }
}








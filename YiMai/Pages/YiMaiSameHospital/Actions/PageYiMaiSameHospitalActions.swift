//
//  PageYiMaiSameHospitalActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageYiMaiSameHospitalActions: PageJumpActions{
    private var TargetView: PageYiMaiSameHospitalBodyView? = nil
    private var SameApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        self.TargetView = self.Target as? PageYiMaiSameHospitalBodyView
        SameApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_SAME_HOSPITAL_LIST,
                               success: GetListSuccess, error: GetListError)
    }
    
    private func GetListSuccess(data: NSDictionary?) {
        TargetView?.Loading?.Hide()
        
        let userInfo = data!["users"] as? [[String: AnyObject]]
        TargetView?.DrawList(userInfo)
    }
    
    private func GetListError(error: NSError) {
        TargetView?.Loading?.Hide()
        TargetView?.DrawBlankContent()
    }
    
    public func GetSameHospitalList(data: [String:AnyObject]?) {
                SameApi?.YMGetSameHospitalList(data)
    }
    
    public func DocCellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView
        let docInfo = cell.UserObjectData as! [String: AnyObject]
        
        PageYiMaiDoctorDetailBodyView.DocId = "\(docInfo["id"]!)"
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    public func DoSearch(input: YMTextField) {
        let keyWord = input.text!
        
        TargetView?.ClearList()
        TargetView?.Loading?.Show()
        GetSameHospitalList(["field": keyWord])
    }
}
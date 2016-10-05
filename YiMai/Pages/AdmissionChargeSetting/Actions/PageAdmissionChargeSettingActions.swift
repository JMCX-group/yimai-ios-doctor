//
//  PageAdmissionChargeSettingActions.swift
//  YiMai
//
//  Created by superxing on 16/8/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAdmissionChargeSettingActions: PageJumpActions {
    var TargetView: PageAdmissionChargeSettingBodyView? = nil
    var SettingApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as? PageAdmissionChargeSettingBodyView
        SettingApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CONFIRM_FEE_SETTING,
                                  success: SaveSuccess, error: SaveFailed)
    }
    
    public func SaveSuccess(data: NSDictionary?) {
//        TargetView?.UpdateVar()
//        YMVar.MyUserInfo = data!["data"] as! [String : AnyObject]
    }
    
    public func SaveFailed(error: NSError) {
//        TargetView?.UpdateVar()
    }
    
    public func ChargeSwitchTouched(sender: UISwitch) {
        TargetView?.SetChargeOn(sender.on)
    }
    
    public func UpadteSetting() {
        TargetView?.UpdateVar()
        print("\(YMVar.MyUserInfo["fee_switch"])")
        print("\(YMVar.MyUserInfo["fee"])")
        print("\(YMVar.MyUserInfo["fee_face_to_face"])")
        SettingApi.YMChangeUserInfo(
            [
                "fee_switch": "\(YMVar.MyUserInfo["fee_switch"]!)",
                "fee": "\(YMVar.MyUserInfo["fee"]!)",
                "fee_face_to_face": "\(YMVar.MyUserInfo["fee_face_to_face"]!)",
            ]
        )
    }
}












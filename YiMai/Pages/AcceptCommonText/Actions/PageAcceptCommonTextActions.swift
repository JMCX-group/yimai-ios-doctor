//
//  PageAcceptCommonTextActions.swift
//  YiMai
//
//  Created by why on 2017/1/5.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageAcceptCommonTextActions: PageJumpActions {
    var TargetView: PageAcceptCommonTextBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageAcceptCommonTextBodyView
    }
    
    func AddCommonText(text: String) {
        let CommonTextDataIndex = "\(YMVar.MyDoctorId).CommonText"
        var commonText =  YMLocalData.GetData(CommonTextDataIndex) as? [String]
        
        if(nil == commonText) {
            commonText = [String]()
        }
        
        if(!commonText!.contains(text)) {
            commonText!.append(text)
        }
        
        YMLocalData.SaveData(commonText!, key: CommonTextDataIndex)
    }
    
    func TextSelected(gr: UIGestureRecognizer) {
        let cell = gr.view as! YMScrollCell
        
        let selectedStr = cell.UserStringData
        TargetView.callback?(selectedStr)
        
        NavController?.popViewControllerAnimated(true)
    }
    
    func GetCommonTextAreaParam() -> [String: Any] {
        var userData = [String:Any]()
        userData["title"] = "添加常用文本"
        userData["placeholder"] = "请输入常用文本"
        userData["callback"] = AddCommonText
        
        return userData
    }

    func AddTextTouched(_: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_AREA, ignoreExists: false, userData: GetCommonTextAreaParam)
    }
}







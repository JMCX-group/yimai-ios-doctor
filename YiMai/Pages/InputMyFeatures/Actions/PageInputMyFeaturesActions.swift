//
//  PageInputMyFeaturesActions.swift
//  YiMai
//
//  Created by superxing on 16/10/10.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageInputMyFeaturesActions: PageJumpActions {
    var TargetView: PageInputMyFeaturesBodyView!
    var FeaturesApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        FeaturesApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CHANGE_USER_TAGS,
                                   success: TagChangeSuccess, error: TagChangeError)
        TargetView = Target as! PageInputMyFeaturesBodyView
    }
    
    func TagChangeSuccess(data: NSDictionary?) {
        
    }
    
    func TagChangeError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func TagAdded(text: String) {
        TargetView.AddTag(text)
    }
    
    func AddTouched(gr: UIGestureRecognizer) {
        PageCommonTextInputViewController.TitleString = "输入特长"
        PageCommonTextInputViewController.Placeholder = "请输入特长名称（最多20字）"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Text
        PageCommonTextInputViewController.InputMaxLen = 20
        PageCommonTextInputViewController.Result = TagAdded
        
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }
    
    func TagTouched(gr: UIGestureRecognizer) {
        let tag = gr.view as! YMTouchableView
        
        var userData = tag.UserObjectData as! [String: AnyObject]
        let tagLabel = userData["label"] as! UILabel
        let tagStatus = userData["status"] as? String
    
        if(nil == tagStatus) {
            tagLabel.textColor = YMColors.White
            tag.layer.borderColor = YMColors.FontBlue.CGColor
            tag.backgroundColor = YMColors.FontBlue
            userData["status"] = "selected"
            tag.UserObjectData = userData
        } else {
            tagLabel.textColor = YMColors.FontGray
            tag.layer.borderColor = YMColors.FontGray.CGColor
            tag.backgroundColor = YMColors.None
            userData["status"] = nil
            tag.UserObjectData = userData
        }
        
        TargetView.SwapDelBtnStatus()
    }
    
    func DelTags(sender: YMButton) {
        TargetView.DoDelete()
    }
}
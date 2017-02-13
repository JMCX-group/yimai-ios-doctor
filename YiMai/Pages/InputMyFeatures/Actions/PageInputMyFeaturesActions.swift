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
    var GetAllTags: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        FeaturesApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CHANGE_USER_TAGS,
                                   success: TagChangeSuccess, error: TagChangeError)
        
        GetAllTags = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_ALL_TAGS,
                                  success: GetAllTagSuccess, error: GetAllTagError)
        TargetView = Target as! PageInputMyFeaturesBodyView
    }
    
    func GetAllTagSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        var tagArr = [[String: AnyObject]]()
        
        for tags in realData {
            let tagsList = tags["tags"] as! [[String: AnyObject]]
            for tag in tagsList {
                let tagDept = YMVar.GetStringByKey(tag, key: "dept")
                let tagName = YMVar.GetStringByKey(tag, key: "name")
                if(YMValueValidator.IsBlankString(tagName)) {
                    continue
                }
                
                tagArr.append(tag)
            }
        }
        TargetView.AllTagsFromServer = tagArr
        TargetView.LoadOtherTags(tagArr)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetAllTagError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView.FullPageLoading.Hide()
    }
    
    func TagChangeSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
    }
    
    func TagChangeError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView.FullPageLoading.Hide()
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
    
    func SaveAllTags(sender: YMButton) {
        TargetView.DoSave()
    }
}
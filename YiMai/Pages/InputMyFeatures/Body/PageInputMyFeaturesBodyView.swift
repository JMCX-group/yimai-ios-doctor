//
//  PageInputMyFeaturesBodyView.swift
//  YiMai
//
//  Created by superxing on 16/10/10.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageInputMyFeaturesBodyView: PageBodyView {
    var FeaturesActions: PageInputMyFeaturesActions!
    var DelButton = YMButton()
    
    var AllTags = [YMTouchableView]()
    
    override func ViewLayout() {
        super.ViewLayout()

        FeaturesActions = PageInputMyFeaturesActions(navController: self.NavController, target: self)
        
        DrawDeleteButton()
    }
    
    func ChangeUserTags() {
        
    }
    
    func AddTag(text: String) {
        var tagExist = false
        
        for tag in AllTags {
            let tagData = tag.UserObjectData as! [String: AnyObject]
            let tagLabel = tagData["label"] as! UILabel
            
            if (text == tagLabel.text) {
                tagExist = true
                break
            }
        }
        
        if(tagExist) {
            YMPageModalMessage.ShowNormalInfo("特长：”\(text)“ 已存在！", nav: self.NavController!)
        } else {
            var tagStrings = YMVar.MyUserInfo["tags"] as? String
            
            if(nil == tagStrings) {
                tagStrings = ""
            }
            let tagArray = tagStrings!.componentsSeparatedByString(",")
            
            var cleanTagArray = [String]()
            for tag in tagArray {
                if(!YMValueValidator.IsEmptyString(tag)) {
                    cleanTagArray.append(tag)
                }
            }
            cleanTagArray.append(text)
            YMVar.MyUserInfo["tags"] = cleanTagArray.joinWithSeparator(",")
            
            DrawFullBody()
            SwapDelBtnStatus()
            
            FullPageLoading.Show()
            FeaturesActions.FeaturesApi.YMChangeUserInfo(["tags": cleanTagArray.joinWithSeparator(",")])
        }
    }
    
    func SwapDelBtnStatus() {

        var hadSomeSelectedTags = false
        for tag in AllTags {
            let tagData = tag.UserObjectData as! [String: AnyObject]
            let tagStatus = tagData["status"] as? String
            
            if(nil != tagStatus) {
                hadSomeSelectedTags = true
                break
            }
        }

        if(hadSomeSelectedTags) {
            DelButton.enabled = true
            DelButton.backgroundColor = YMColors.CommonBottomBlue
        } else {
            DelButton.enabled = false
            DelButton.backgroundColor = YMColors.CommonBottomGray
        }
    }
    
    func DoDelete() {
        var tagStringArray = [String]()
        for tag in AllTags {
            let tagData = tag.UserObjectData as! [String: AnyObject]
            let tagStatus = tagData["status"] as? String
            let tagLabel = tagData["label"] as! UILabel
            
            if(nil == tagStatus) {
                tagStringArray.append(tagLabel.text!)
            }
        }
        
        let tagString = tagStringArray.joinWithSeparator(",")
        
        YMVar.MyUserInfo["tags"] = tagString
        DrawFullBody()
        SwapDelBtnStatus()
    }
    
    func DrawDeleteButton() {
        DelButton.setTitle("删除选中的标签", forState: UIControlState.Normal)
        DelButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        DelButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        DelButton.titleLabel?.font = YMFonts.YMDefaultFont(36.LayoutVal())
        DelButton.backgroundColor = YMColors.CommonBottomGray
        DelButton.enabled = false
        
        DelButton.addTarget(FeaturesActions, action: "DelTags:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ParentView?.addSubview(DelButton)
        DelButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
    }
    
    func TagBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {
        let tag = YMLayout.GetTouchableView(useObject: FeaturesActions, useMethod: "TagTouched:".Sel())
        tag.backgroundColor = YMColors.None
        
        let tagLabel = YMLayout.GetNomalLabel(tagText, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        tag.frame = CGRect(x: 0,y: 0,width: tagInnerPadding*2 + tagLabel.width,height: tagHeight)
        tag.addSubview(tagLabel)

        tagLabel.anchorInCenter(width: tagLabel.width, height: tagLabel.height)
        tag.layer.borderColor = YMColors.FontGray.CGColor
        tag.layer.borderWidth = 2.LayoutVal()
        tag.layer.masksToBounds = true
        tag.layer.cornerRadius = 10.LayoutVal()

        tag.UserObjectData = ["label": tagLabel]
        
        AllTags.append(tag)
        return tag
    }
    
    func DrawFullBody() {
        let tags = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "tags")
        
        AllTags.removeAll()
        let lastLine = YMLayout.DrawTagList(tags.componentsSeparatedByString(","), tagPanel: BodyView,
                                            tagBuilder: TagBuilder, lineWidth: 590.LayoutVal(), lineHeight: 40.LayoutVal(),
                                            firstLineXPos: 80.LayoutVal(), firstLineYPos: 90.LayoutVal(), lineSpace: 30.LayoutVal(),
                                            tagSpace: 10.LayoutVal(), tagInnerPadding: 23.LayoutVal())
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: lastLine)
    }
    
    func DrawTopAddButton(topView: UIView) {
        let addIcon = YMLayout.GetTouchableImageView(useObject: FeaturesActions, useMethod: "AddTouched:".Sel(), imageName: "CommonPlusIcon")
        
        topView.addSubview(addIcon)
        
        addIcon.anchorInCorner(Corner.BottomRight, xPad: 34.LayoutVal(), yPad: 24.LayoutVal(), width: addIcon.width, height: addIcon.height)
    }
    
 
    func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
}












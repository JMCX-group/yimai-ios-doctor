//
//  PageAcceptCommonTextBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/5.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageAcceptCommonTextBodyView: PageBodyView {
    var TextActions: PageAcceptCommonTextActions!
    var callback: ((String) -> Void)? = nil
    var CurrentCommonTextList = [String]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        TextActions = PageAcceptCommonTextActions(navController: NavController!, target: self)
    }
    
    func DrawFullBody() {
        let CommonTextDataIndex = "\(YMVar.MyDoctorId).CommonText"

        YMLayout.ClearView(view: BodyView)
        var commonText =  YMLocalData.GetData(CommonTextDataIndex) as? [String]
        
        if(nil == commonText) {
            commonText = [String]()
        }

        CurrentCommonTextList = commonText!
        DrawList(commonText!)
    }
    
    func DrawList(textArr: [String]) {
        var prev: UIView? = nil
        for (idx, text) in textArr.enumerate() {
            let label = YMLayout.GetNomalLabel(text, textColor: YMColors.FontGray, fontSize: 28.LayoutVal(), maxWidth: 670.LayoutVal())
            let cell = YMLayout.GetScrollCell(useObject: TextActions, useMethod: "TextSelected:".Sel())

            cell.UserStringData = text
            cell.UserObjectData = idx
            cell.addSubview(label)
            
            BodyView.addSubview(cell)
            var cellHeight = label.height + 40.LayoutVal()
            if(cellHeight < 80.LayoutVal()) {
                cellHeight = 80.LayoutVal()
            }
            if(nil == prev) {
                cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: cellHeight)
            } else {
                cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx,
                           width: YMSizes.PageWidth, height: cellHeight)
            }

            label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: label.width, height: label.height)
            
            cell.SetCellBtn("删除", titleColor: YMColors.White, bkgColor: UIColor.redColor(),
                            fontSize: 40.LayoutVal(), padding: 40.LayoutVal(), callback: { (_, idx) in
                                self.CurrentCommonTextList.removeAtIndex(idx as! Int)
                                let CommonTextDataIndex = "\(YMVar.MyDoctorId).CommonText"
                                YMLocalData.SaveData(self.CurrentCommonTextList, key: CommonTextDataIndex)
                                self.DrawFullBody()
            })

            prev = cell
        }
        
        let addText = YMLayout.GetTouchableView(useObject: TextActions, useMethod: "AddTextTouched:".Sel())
        BodyView.addSubview(addText)
        
        if(nil == prev) {
            addText.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        } else {
            addText.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: addText)
        
        let icon = YMLayout.GetSuitableImageView("YMIconAddCommonText")
        let text = YMLayout.GetNomalLabel("添加常用文本", textColor: YMColors.FontBlue, fontSize: 28.LayoutVal())
        
        addText.addSubview(icon)
        addText.addSubview(text)
        
        icon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
        text.align(Align.ToTheRightCentered, relativeTo: icon, padding: 20.LayoutVal(), width: text.width, height: text.height)
        
    }
}













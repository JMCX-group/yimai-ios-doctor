//
//  PageBlacklistBodyView.swift
//  YiMai
//
//  Created by why on 2016/12/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageBlacklistBodyView: PageBodyView {
    var ListActions: PageBlacklistActions!
    var DocList = [[String: AnyObject]]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ListActions = PageBlacklistActions(navController: NavController!, target: self)
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        Clear()
        if(0 == data.count) {
            return
        }
        
        var cell: YMTouchableView? = nil
        for doc in data {
            cell = DrawFriendsCell(doc, prevCell: cell)
        }
        DocList = data
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: cell, padding: 128.LayoutVal())
        
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: YMTouchableView?) -> YMTouchableView? {
        let head = YMVar.GetStringByKey(data, key: "head_url")
        let name = YMVar.GetStringByKey(data, key: "name")
        let hospital = data[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as? [String: AnyObject]
        let department = data[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as? [String: AnyObject]
        let jobTitle = YMVar.GetStringByKey(data, key: "job_title", defStr: "医生")
        let userId = data[YMYiMaiStrings.CS_DATA_KEY_USER_ID] as! String
        
        let curListStr = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist")
        let curList = curListStr.componentsSeparatedByString(",")
        if(!curList.contains(userId)) {
            return prevCell
        }
        
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        let removeBtn = YMButton()
        
        nameLabel.text = name
        nameLabel.textColor = YMColors.FontBlue
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.FontBlue

        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.FontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = YMVar.GetStringByKey(department, key: "name")
        deptLabel.textColor = YMColors.FontBlue
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = YMVar.GetStringByKey(hospital, key: "name")
        hosLabel.textColor = YMColors.FontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        let cell = YMTouchableView()
        cell.backgroundColor = YMColors.White
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        cell.addSubview(removeBtn)
        
        removeBtn.setTitle("移出黑名单", forState: UIControlState.Normal)
        removeBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        removeBtn.titleLabel?.font = YMFonts.YMDefaultFont(22.LayoutVal())
        removeBtn.sizeToFit()
        removeBtn.addTarget(ListActions, action: "RemoveFromBlacklist:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        removeBtn.UserStringData = userId
        
        BodyView.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: YMSizes.PageWidth, height: 151.LayoutVal())
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: 151.LayoutVal())
        }
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        removeBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: removeBtn.width, height: removeBtn.height)
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head, fullUrl: nil, makeItRound: true)
        
        return cell
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
}



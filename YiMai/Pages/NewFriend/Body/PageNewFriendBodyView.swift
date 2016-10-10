//
//  PageNewFriendBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageNewFriendBodyView: PageBodyView {
    private var NewFriendActions: PageNewFriendActions? = nil

    public var SearchInput: YMTextField? = nil
    private var SearchPanel = UIView()
    private let QuickLinkPanel = UIView()
    private let QuickLinkPanelBkg = YMLayout.GetSuitableImageView("NewFriendsTemp")
    private let ListPanel = UIScrollView()
    private var LastCell: YMTouchableView? = nil

    override func ViewLayout() {
        super.ViewLayout()
        
        NewFriendActions = PageNewFriendActions(navController: self.NavController!, target: self)
        
        DrawSearchPanel()
        DrawQuickLinkPanel()
    }

    public func GetList() {
        NewFriendActions?.GetList()
    }
    
    public func LoadData(data: [[String: AnyObject]]) {
        DrawFriendsList(data)
    }
    
    private func DrawFriendsList(data: [[String: AnyObject]]) {
        func DrawStatus(status: String, cell: YMTouchableView) {
            if("waitForFriendAgree" == status) {
                let label = UILabel()
                label.text = "等待验证"
                label.textColor = YMColors.FontLightGray
                label.font = YMFonts.YMDefaultFont(24.LayoutVal())
                label.sizeToFit()
                
                cell.addSubview(label)
                label.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 40.LayoutVal(), width: label.width, height: label.height)
            } else if ("waitForSure" == status) {
                let agreeButton = YMButton()
                agreeButton.addTarget(NewFriendActions!, action: "Agree:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
                
                agreeButton.setTitle("同意", forState: UIControlState.Normal)
                agreeButton.setTitle("已添加", forState: UIControlState.Disabled)
                agreeButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
                agreeButton.setTitleColor(YMColors.FontLightGray, forState: UIControlState.Disabled)
                agreeButton.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
                agreeButton.backgroundColor = YMColors.FontBlue
                agreeButton.layer.cornerRadius = 8.LayoutVal()
                agreeButton.layer.masksToBounds = true
                
                cell.addSubview(agreeButton)
                agreeButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 28.LayoutVal(), width: 100.LayoutVal(), height: 40.LayoutVal())
                agreeButton.UserObjectData = cell.UserObjectData
            } else {
                let label = UILabel()
                label.text = "已添加"
                label.textColor = YMColors.FontLightGray
                label.font = YMFonts.YMDefaultFont(24.LayoutVal())
                label.sizeToFit()
                
                cell.addSubview(label)
                label.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 40.LayoutVal(), width: label.width, height: label.height)
            }
        }
        
        BodyView.addSubview(ListPanel)
        ListPanel.alignAndFill(align: Align.UnderMatchingLeft, relativeTo: QuickLinkPanel, padding: 0)
        
        for v in data {
            LastCell = PageSearchResultCell.LayoutACell(ListPanel, info: v, prev: LastCell,
                                                        act: NewFriendActions!, sel: PageJumpActions.PageJumpToByViewSenderSel, highlight: ActiveType.URL)
            
            DrawStatus(v["status"]! as! String, cell: LastCell!)
            
        }
        
        YMLayout.SetVScrollViewContentSize(ListPanel, lastSubView: LastCell, padding: 130.LayoutVal())
    }
    
    private func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        let param = TextFieldCreateParam()
        param.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        param.FontColor = YMColors.FontBlue
        param.Placholder = "搜索"
        param.FontSize = 26.LayoutVal()
        
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 20)
        SearchInput?.SetLeftPadding(searchIconView)
        SearchInput?.SetRightPaddingWidth(20.LayoutVal())
        
        SearchPanel.addSubview(SearchInput!)
        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
    }
    
    private func DrawQuickLinkPanel() {
        BodyView.addSubview(QuickLinkPanel)
        BodyView.addSubview(QuickLinkPanel)
        QuickLinkPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: QuickLinkPanelBkg.height)
        
        QuickLinkPanel.addSubview(QuickLinkPanelBkg)
        QuickLinkPanelBkg.fillSuperview()
        
        let contactListBtn = YMButton()
        let qrBtn = YMButton()
        
        QuickLinkPanel.addSubview(contactListBtn)
        QuickLinkPanel.addSubview(qrBtn)
        
        QuickLinkPanel.groupAndFill(group: Group.Horizontal, views: [contactListBtn, qrBtn], padding: 0)
        
        contactListBtn.addTarget(NewFriendActions!, action: "JumpToContactPage:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        qrBtn.addTarget(NewFriendActions!, action: "JumpToQRPage:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
//        QuickLinkPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: QuickLinkPanel.height)
    }
    
    public func Clear() {
        YMLayout.ClearView(view: ListPanel)
        LastCell = nil
    }
}





















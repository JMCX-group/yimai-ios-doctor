//
//  PageYiMaiTopView.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiTopView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions: PageYiMaiActions? = nil
    
    public var QRButton: YMTouchableImageView? = nil
    public var AddFriendButton: YMTouchableImageView? = nil
    public var PageContentTab: UIView? = nil
    
    public static var TabButtonIndex = YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE
    
    private let R1TabSelector: Selector = "YiMaiR1TabTouched:".Sel()
    private let R2TabSelector: Selector = "YiMaiR2TabTouched:".Sel()
    private let AddFriendsSelector: Selector = "AddFriendButtonTouched:".Sel()
    
    private let TopView = UIView()
    
    private let TabButtonMap = [
        YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE: YMButton(),
        YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE: YMButton(),
        YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE: YMButton()
    ]
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PageYiMaiActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        ViewLayout()
    }
    
    private func ViewLayout(){
        self.ParentView!.addSubview(self.TopView)
        
        self.TopView.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.ScreenWidth, height: YMSizes.PageTopHeight)
        
        DrawTopBackground()
        DrawTopButtons()
        DrawTopTab()
        
        SetSelectedTab(nil)
    }
    
    private func DrawTopButtons() {
        let qrImage = UIImage(named: "TopViewQRButton")
        QRButton = YMLayout.GetTouchableImageView(useObject: self.Actions!,
                                                  useMethod: "QRButtonTouched:".Sel(),
                                                  image: qrImage!)
        
        let addFriendImage = UIImage(named: "PageYiMaiAddFriendButton")
        AddFriendButton = YMLayout.GetTouchableImageView(useObject: self.Actions!, useMethod: PageJumpActions.PageJumpToByImageViewSenderSel, image: addFriendImage!)
        AddFriendButton?.UserStringData = YMCommonStrings.CS_PAGE_YIMAI_ADD_FRIENDS_NAME
        
        TopView.addSubview(QRButton!)
        TopView.addSubview(AddFriendButton!)
        
        QRButton!.anchorInCorner(Corner.BottomLeft, xPad: 28.LayoutVal(), yPad: 24.LayoutVal(), width: QRButton!.width, height: QRButton!.height)
        AddFriendButton!.anchorInCorner(Corner.BottomRight, xPad: 20.LayoutVal(), yPad: 24.LayoutVal(), width: AddFriendButton!.width, height: AddFriendButton!.height)
    }
    
    private func DrawTopBackground() {
        let topBackground = YMLayout.GetSuitableImageView("TopViewBackgroundNormal")
        TopView.addSubview(topBackground)
        topBackground.fillSuperview()
    }
    
    private func DrawTopTab() {
        DrawTabBackground()
        DrawTabButtons()
    }
    
    private func DrawTabBackground() {
        PageContentTab = YMLayout.GetSuitableImageView("PageYiMaiTabBackground")
        TopView.addSubview(PageContentTab!)
        PageContentTab!.anchorInCorner(Corner.BottomLeft, xPad: 150.LayoutVal(), yPad: 20.LayoutVal(), width: PageContentTab!.width, height: PageContentTab!.height)
    }
    
    private func SetTabButtonStyle(button: YMButton, title: String) {
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        button.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        
        button.UserStringData = title
    }
    
    private func ResetTabButtonStyle() {
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]?.backgroundColor = UIColor.clearColor()
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]?.backgroundColor = UIColor.clearColor()
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]?.backgroundColor = UIColor.clearColor()
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]?.addTarget(Actions!, action: R1TabSelector, forControlEvents: UIControlEvents.TouchUpInside)
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]?.addTarget(Actions!, action: R2TabSelector, forControlEvents: UIControlEvents.TouchUpInside)
    }

    private func DrawTabButtons() {
        SetTabButtonStyle(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]!, title: YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE)
        SetTabButtonStyle(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]!, title: YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE)
        SetTabButtonStyle(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]!, title: YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE)
        
        TopView.addSubview(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]!)
        TopView.addSubview(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]!)
        TopView.addSubview(TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]!)
        
        let buttonWidth = 148.LayoutVal()
        let buttonHeight = 46.LayoutVal()
        
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]?.anchorInCorner(Corner.BottomLeft, xPad: 153.LayoutVal(), yPad: 22.LayoutVal(), width: buttonWidth, height: buttonHeight)
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]?.align(Align.ToTheRightMatchingTop,
            relativeTo: TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE]!, padding: 0,
            width: buttonWidth, height: buttonHeight)
        
        TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE]?.align(Align.ToTheRightMatchingTop,
            relativeTo: TabButtonMap[YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE]!, padding: 0,
            width: buttonWidth, height: buttonHeight)
    }
    
    public func SetSelectedTab(tabname: String?) {
        var indexName = PageYiMaiTopView.TabButtonIndex
        if(nil != tabname){
            indexName = tabname!
        }
        
        let buttonToSet = TabButtonMap[indexName]
        if(nil != buttonToSet) {
            ResetTabButtonStyle()

            buttonToSet?.backgroundColor = YMColors.White
            buttonToSet?.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        }
    }
}

































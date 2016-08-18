//
//  PageYiMaiAddContactsFriendsBootomView.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiAddContactsFriendsBootomView {
    public var Actions: YiMaiAddContactsFriendsActions? = nil
    public var Parent: UIView? = nil
    public var AddAllFriendsBottomView: YMTouchableView? = nil
    public var InviteAllOthersBottomView: YMTouchableView? = nil

    init(action: YiMaiAddContactsFriendsActions, parent: UIView){
        self.Actions = action
        self.Parent = parent

        DrawBottom()
    }
    
    private func GetBottomView(title: String, bottomView: YMTouchableView) {
        Parent?.addSubview(bottomView)
        
        bottomView.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.PageBottomHeight)
        
        let bottomLabel = UILabel()
        bottomLabel.text = title
        bottomLabel.textColor = YMColors.FontGray
        bottomLabel.font = YMFonts.YMDefaultFont(34.LayoutVal())
        bottomLabel.sizeToFit()
        
        bottomView.addSubview(bottomLabel)
        bottomLabel.anchorInCenter(width: bottomLabel.width, height: bottomLabel.height)
        bottomView.backgroundColor = YMColors.BackgroundGray
        
        bottomView.UserObjectData = bottomLabel
        bottomView.hidden = true
    }
    
    private func DrawBottom() {
        AddAllFriendsBottomView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AddAllContactsFriends:".Sel())
        InviteAllOthersBottomView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "InviteAllOthersRegisterYiMai:".Sel())
        
        GetBottomView("添加全部好友", bottomView: AddAllFriendsBottomView!)
        GetBottomView("邀请通讯录里的所有医生", bottomView: InviteAllOthersBottomView!)
    }
    
    public func EnableAddButton() {
        let btnLabel = AddAllFriendsBottomView?.UserObjectData as! UILabel

        btnLabel.textColor = YMColors.White
        AddAllFriendsBottomView?.backgroundColor = YMColors.CommonBottomBlue
        
        AddAllFriendsBottomView?.hidden = false
        InviteAllOthersBottomView?.hidden = true
    }
    
    public func EnabelInviteButton() {
        let btnLabel = InviteAllOthersBottomView?.UserObjectData as! UILabel
        
        btnLabel.textColor = YMColors.White
        InviteAllOthersBottomView?.backgroundColor = YMColors.CommonBottomBlue
        
        InviteAllOthersBottomView?.hidden = false
        AddAllFriendsBottomView?.hidden = true
    }
}































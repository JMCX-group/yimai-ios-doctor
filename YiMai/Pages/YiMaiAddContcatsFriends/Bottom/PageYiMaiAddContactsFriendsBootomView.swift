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
    private var BottomView: YMTouchableView? = nil

    init(action: YiMaiAddContactsFriendsActions, parent: UIView){
        self.Actions = action
        self.Parent = parent

        DrawBottom()
    }
    
    private func DrawBottom() {
        BottomView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AddAllContactsFriends:")
        Parent?.addSubview(BottomView!)
        
        BottomView?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.PageBottomHeight)
        
        let bottomLabel = UILabel()
        bottomLabel.text = "添加通讯录的所有医生"
        bottomLabel.textColor = YMColors.White
        bottomLabel.font = YMFonts.YMDefaultFont(34.LayoutVal())
        bottomLabel.sizeToFit()
        
        BottomView?.addSubview(bottomLabel)
        bottomLabel.anchorInCenter(width: bottomLabel.width, height: bottomLabel.height)
        BottomView?.backgroundColor = YMColors.CommonBottomBlue
    }
}
//
//  PageSYSBroadcastViewController.swift
//  YiMai
//
//  Created by superxing on 16/10/13.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Neon

class PageSYSBroadcastViewController: PageViewController {
    var BodyView: PageSYSBroadcastBodyView!
    
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSYSBroadcastBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "系统广播", navController: self.NavController!)
//        DrawClearAllReadFlag()
    }
    
    func DrawClearAllReadFlag() {
//        let btn = YMLayout.GetNomalLabel("全部设为已读", textColor: YMColors.White, fontSize: 28.LayoutVal())
//        TopView?.TopViewPanel.addSubview(btn)
//        
//        btn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 26.LayoutVal(), width: btn.width, height: btn.height)
//        btn.SetTouchable(withObject: BodyView.BroadcastActions, useMethod: "SetAllReaden:".Sel())
    }
    
    override func PagePreRefresh() {
        BodyView.CurrentPage = 1
        BodyView.GetList()
    }
}
















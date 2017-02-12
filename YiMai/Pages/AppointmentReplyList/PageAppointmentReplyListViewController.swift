//
//  PageAppointmentReplyListViewController.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Neon

class PageAppointmentReplyListViewController: PageViewController {
    var BodyView: PageAppointmentReplyListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentReplyListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "约诊回复列表", navController: self.NavController!)
        DrawClearAllReadFlag()
    }
    
    func DrawClearAllReadFlag() {
        let btn = YMLayout.GetNomalLabel("全部设为已读", textColor: YMColors.White, fontSize: 28.LayoutVal())
        TopView?.TopViewPanel.addSubview(btn)
        
        btn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 26.LayoutVal(), width: btn.width, height: btn.height)
        btn.SetTouchable(withObject: BodyView.ListActions, useMethod: "SetAllReaden:".Sel())
    }
    
    override func PagePreRefresh() {
//        BodyView.ListActions.ClearListApi.YMClearAllNewAppointment()
        if(self.isMovingToParentViewController()) {
            YMLayout.ClearView(view: BodyView.BodyView)
            BodyView.FullPageLoading.Show()
            BodyView.ListActions.GetListApi.YMGetAllNewAppointmentMsg()
        } else {
            BodyView.LoadData(BodyView.PrevData)
        }
    }
}

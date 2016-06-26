//
//  PageYiMaiDoctorDetailBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiDoctorDetailBodyView: PageBodyView {
    private var DetailActions: PageYiMaiDoctorDetailActions? = nil
    public var Loading: YMPageLoadingView? = nil
    public static var DocId: String = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        DetailActions = PageYiMaiDoctorDetailActions(navController: self.NavController, target: self)
        GetDocInfo()
    }
    
    public func GetDocInfo(){
        DetailActions!.GetInfo()
    }
    
    public func LoadData(data: [String: AnyObject]) {
        DrawBasicPanel()
//        DrawButtonGroup()
//        DrawTags()
//        DrawCommonFriends()
//        DrawIntro()
//        DrawCollege()
    }
    
    public func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
    
    public func DrawBasicPanel() {
        let basicPanel = UIView()
        BodyView.addSubview(basicPanel)
        basicPanel.anchorToEdge(Edge.Top, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 150.LayoutVal())
        
        let userHead = YMLayout.GetSuitableImageView("GetCommonUserHeadImage")
//        let userName = UILabel()
//        let userName = UILabel()
//        let userName = UILabel()
//        let userName = UILabel()
//        let userName = UILabel()
    }
}
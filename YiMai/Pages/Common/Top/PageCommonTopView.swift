//
//  PageCommonTopView.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonTopView : NSObject {
    private let TopViewPanel : UIView = UIView()
    private var TopBackground = UIImageView()
    private var TopTitle = UILabel()
    private var TopGoBackBtn = UIImageView()
    
    private var ParentView:UIView? = nil
    private var TitleString = ""
    private var CommonActions : YMCommonActions? = nil

    convenience init(parentView:UIView, titleString:String, navController:UINavigationController? = nil) {
        self.init()
        self.ParentView = parentView
        self.TitleString = titleString
        
        self.ViewLayout(navController)
    }
    
    private func ViewLayout(navController:UINavigationController?){
        ParentView!.addSubview(TopViewPanel)
        TopViewPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: YMSizes.PageTopHeight)

        DrawBackgroundLayer()
        DrawTitle()
        
        if(nil != navController){
            self.SetGoBackButton(navController!)
        }
    }
    
    private func DrawBackgroundLayer() {
        TopBackground = YMLayout.GetSuitableImageView("TopViewBackgroundNormal")
        TopViewPanel.addSubview(TopBackground)
        TopBackground.fillSuperview()
    }
    
    private func DrawTitle(){
        TopTitle.text = self.TitleString
        TopTitle.font = UIFont.systemFontOfSize(YMSizes.PageTopTitleFontSize)
        TopTitle.textColor = YMColors.White
        TopTitle.textAlignment = NSTextAlignment.Center
        
        TopViewPanel.addSubview(TopTitle)
        TopTitle.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 26.LayoutVal(), otherSize: YMSizes.PageTopTitleFontSize)
    }
    
    private func SetGoBackButton(navController:UINavigationController) {
        CommonActions = YMCommonActions(navController: navController)
        TopGoBackBtn = YMLayout.GetTouchableImageView(useObject: CommonActions!, useMethod: "GoBack:", imageName: "TopViewButtonGoBack")
        
        TopViewPanel.addSubview(TopGoBackBtn)
        TopGoBackBtn.anchorInCorner(Corner.BottomLeft, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: TopGoBackBtn.width, height: TopGoBackBtn.height)
    }
}
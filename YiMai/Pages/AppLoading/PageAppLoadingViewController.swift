//
//  PageAppLoadingViewController.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Graph

public class PageAppLoadingViewController: PageViewController {
    private var Actions: PageAppLoadingActions? = nil
    public var LoginInfo: Entity? = nil
    public var LoadingIndc: YMPageLoadingView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppLoadingActions(navController: self.NavController!, target: self)
        let loadingImage = YMLayout.GetSuitableImageView("AppLoadingPage")
        self.view.addSubview(loadingImage)
        loadingImage.anchorInCenter(width: loadingImage.width, height: loadingImage.height)
        loadingImage.alpha = 0.0
        
        LoadingIndc = YMPageLoadingView(parentView: self.SelfView!)
        LoginInfo = YMLocalData.GetLoginInfo()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        loadingImage.opaque = true
        loadingImage.alpha = 1.0
        UIView.setAnimationDelegate(self)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
        UIView.setAnimationDidStopSelector("animationDidStop:".Sel())
        

    }

    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        YMDelay(1.0) { () -> () in
            if(nil == self.LoginInfo) {
                self.Actions?.JumpToLogin()
            } else {
                self.Actions?.DoLogin()
            }
        }
    }
}


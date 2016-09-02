//
//  PageFace2FaceQRViewController.swift
//  YiMai
//
//  Created by why on 16/4/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageFace2FaceQRViewController: PageViewController {
    private var Actions: PageFace2FaceQRActions? = nil
    private var BodyView: PageFace2FaceQRBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageFace2FaceQRActions(navController: NavController)
        BodyView = PageFace2FaceQRBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "当面咨询", navController: NavController)
        
        BodyView?.DrawFastSettingBtn(TopView!.TopViewPanel)
    }
}

//
//  PageFace2FaceInfoInputViewController.swift
//  YiMai
//
//  Created by why on 16/4/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageFace2FaceInfoInputViewController: PageViewController {
    private var Actions: PageFace2FaceInfoInputActions? = nil
    private var BodyView: PageFace2FaceInfoInputBodyView? = nil
    
    override func PageLayout() {
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        let selfView = self.view
        let selfNav = self.navigationController
        
        Actions = PageFace2FaceInfoInputActions(navController: selfNav)
        BodyView = PageFace2FaceInfoInputBodyView(parentView: selfView, navController: selfNav!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: selfView, titleString: "当面咨询", navController: selfNav)
    }
}

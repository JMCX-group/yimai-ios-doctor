//
//  PageRegisterViewController.swift
//  YiMai
//
//  Created by why on 16/4/19.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageRegisterViewController: PageViewController {
    private var BodyView : PageRegisterBodyView? = nil
    
    public static var RegPhone: String = ""
    public static var RegPassword: String = ""
    public static var RegInvitedCode: String = ""
    
   override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        YMCoreDataEngine.EngineInitialize()

        BodyView = PageRegisterBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMRegisterStrings.CS_REGISTER_PAGE_TITLE, navController: self.navigationController)
    }
}

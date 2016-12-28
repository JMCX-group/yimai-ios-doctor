//
//  PagePersonalChangePhoneViewController.swift
//  YiMai
//
//  Created by why on 2016/12/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageChangePhoneViewController: PageViewController {
    var BodyView: PageChangePhoneBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageChangePhoneBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "", navController: NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.PhoneInput.text = ""
        BodyView.VerifyCodeInput.text = ""
        BodyView.StopCountDown()
        BodyView.EnableGetVerifyCodeBtn()
    }
}















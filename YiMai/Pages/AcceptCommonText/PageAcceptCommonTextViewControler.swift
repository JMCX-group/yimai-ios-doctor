//
//  PageAcceptCommonText.swift
//  YiMai
//
//  Created by why on 2017/1/5.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit

class PageAcceptCommonTextViewControler: PageViewController {
    var BodyView: PageAcceptCommonTextBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAcceptCommonTextBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "常用文本", navController: NavController!, before: nil)
    }
    
    override func PagePreRefresh() {
        BodyView.DrawFullBody()
        BodyView.callback = UserData as? ((String) -> Void)
    }
}











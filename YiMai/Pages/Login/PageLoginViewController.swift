//
//  PageLoginViewController.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageLoginViewController: PageViewController {
    private var BodyView : PageLoginBodyView? = nil

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func PageLayout(){
        super.PageLayout()

        BodyView = PageLoginBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMLoginStrings.CS_LOGIN_PAGE_TITLE)
    }
    
    override func PageDisapeared() {
        BodyView?.ClearLoginControls()
    }
}

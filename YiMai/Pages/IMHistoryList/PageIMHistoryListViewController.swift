//
//  PageIMHistoryListViewController.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit

class PageIMHistoryListViewController: PageViewController {
    var BodyView: PageIMHistoryListBodyView!

    override func PageLayout() {
        super.PageLayout()
    }
    
    override func PagePreRefresh() {
        let targetId = UserData as! String
    }
    
    override func PageDisapeared() {
        BodyView.Clear()
    }
}












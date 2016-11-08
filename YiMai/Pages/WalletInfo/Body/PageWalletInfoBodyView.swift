//
//  PageWalletInfoBodyView.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageWalletInfoBodyView: PageBodyView {
    var WalletActions: PageWalletInfoActions!

    override func ViewLayout() {
        super.ViewLayout()
        
        WalletActions = PageWalletInfoActions(navController: self.NavController!, target: self)
    }
}








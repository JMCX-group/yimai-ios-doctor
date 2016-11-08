//
//  PageAuthProcessingBodyView.swift
//  YiMai
//
//  Created by old-king on 16/11/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageAuthProcessingBodyView: PageBodyView {
    var ProcessingActions: PageAuthProcessingActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ProcessingActions = PageAuthProcessingActions(navController: self.NavController, target: self)
        DrawFullBody()
    }
    
    func DrawFullBody() {
        let info = YMLayout.GetNomalLabel("您的信息正在认证中！", textColor: YMColors.FontGray, fontSize: 48.LayoutVal())
        
        BodyView.addSubview(info)
        info.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: info.width, height: info.height)
    }
}



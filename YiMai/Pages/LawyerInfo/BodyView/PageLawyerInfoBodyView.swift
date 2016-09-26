//
//  PageLawyerInfoBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageLawyerInfoBodyView: PageBodyView {
    override func ViewLayout() {
        super.ViewLayout()
        
        let info = YMLayout.GetSuitableImageView("YMLawyerInfo")
        BodyView.addSubview(info)
        info.anchorToEdge(Edge.Top, padding: 0, width: info.width, height: info.height)

        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: info)
    }
}





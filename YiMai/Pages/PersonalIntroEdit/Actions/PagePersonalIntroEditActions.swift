//
//  PagePersonalIntroEditActions.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalIntroEditActions: PageJumpActions {
    private var TargetController: PagePersonalIntroEditViewController? = nil
    
    override func ExtInit() {
        TargetController = self.Target as? PagePersonalIntroEditViewController
    }

    public func UpdateIntro(_: YMButton) {
        PagePersonalIntroEditViewController.IntroText = TargetController!.BodyView!.TextInput!.text
        self.NavController?.popViewControllerAnimated(true)
    }
}
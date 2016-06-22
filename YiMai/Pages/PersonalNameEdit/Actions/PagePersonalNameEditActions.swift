//
//  PagePersonalNameEditActions.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalNameEditActions: PageJumpActions {
    private var TargetController: PagePersonalNameEditViewController? = nil
    
    override func ExtInit() {
        TargetController = self.Target as? PagePersonalNameEditViewController
    }
    
    public func UpdateIntro(_: YMButton) {
        PagePersonalNameEditViewController.UserName = TargetController!.BodyView!.TextInput!.text!
        self.NavController?.popViewControllerAnimated(true)
    }
}
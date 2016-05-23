//
//  PageRegisterActions.swift
//  YiMai
//
//  Created by why on 16/4/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageRegisterActions: PageJumpActions {
    private var TargetBodyView : PageRegisterBodyView? = nil
    
    convenience init(navController: UINavigationController, bodyView: PageRegisterBodyView) {
        self.init()
        self.TargetBodyView = bodyView
        self.NavController = navController
    }

    public func AgreementButtonTouched(sender: YMButton) {
        TargetBodyView?.ToggleAgreementStatus()
    }

    public func AgreementImageTouched(sender: UITapGestureRecognizer) {
        TargetBodyView?.ToggleAgreementStatus()
    }
}
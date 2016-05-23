//
//  PageRegisterPersonalInfoActions.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageRegisterPersonalInfoActions: PageJumpActions {
    convenience public init(navController: UINavigationController, bodyView: PageRegisterPersonalInfoHospitalBodyView) {
        self.init()
        self.NavController = navController
    }
    
    public func ShowCitySelect(sender: YMTextField) {
        print("text right side touched")
    }
}
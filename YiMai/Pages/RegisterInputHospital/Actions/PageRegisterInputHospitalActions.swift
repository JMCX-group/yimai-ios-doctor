//
//  PageRegisterInputHospitalActions.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageRegisterInputHospitalActions: PageJumpActions {
    convenience public init(navController: UINavigationController, bodyView: PageRegisterInputHospitalBodyView) {
        self.init()
        self.NavController = navController
    }
}
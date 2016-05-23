//
//  PageRegisterSelectHospitalActions.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageRegisterSelectHospitalActions: PageJumpActions {
    convenience public init(navController: UINavigationController, bodyView: PageRegisterSelectHospitalBodyView) {
        self.init()
        self.NavController = navController
    }
}
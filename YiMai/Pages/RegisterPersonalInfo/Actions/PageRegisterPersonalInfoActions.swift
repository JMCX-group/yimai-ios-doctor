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
    convenience public init(navController: UINavigationController, bodyView: PageRegisterPersonalInfoBodyView) {
        self.init()
        self.NavController = navController
    }
    
    public func ShowHospital(sender: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func ShowCity(sender: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
}
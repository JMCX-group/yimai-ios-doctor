//
//  PaperCardPreviewActions.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PaperCardPreviewActions: PageJumpActions {
    override func ExtInit() {
        super.ExtInit()
    }
    
    func ConfirmTouched(_: YMButton)  {
        let controllers = self.NavController!.viewControllers
        
        let targetController = controllers[controllers.count - 3]
        
        self.NavController?.popToViewController(targetController, animated: true)
    }
}












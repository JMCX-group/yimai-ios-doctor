//
//  PageDoctorAtuhActions.swift
//  YiMai
//
//  Created by superxing on 16/9/29.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
class PageDoctorAuthActions: PageJumpActions {
    var TargetView: PageDoctorAuthBodyView!

    override func ExtInit() {
        super.ExtInit()
        TargetView = Target as! PageDoctorAuthBodyView
    }
    
    func AddImageTouched(gr: UIGestureRecognizer) {
        let imgView = gr.view as! UIImageView
        TargetView.ShowPhotoPicker(imgView)
    }
    
    func RemoveImageTouched(gr: UIGestureRecognizer) {
        
    }
    
    func DoSubmit(sender: YMButton) {
        self.NavController!.popViewControllerAnimated(true)
    }
}
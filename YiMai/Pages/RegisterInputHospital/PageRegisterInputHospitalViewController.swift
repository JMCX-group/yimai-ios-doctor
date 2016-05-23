//
//  PageRegisterInputHospitalViewController.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageRegisterInputHospitalViewController: PageViewController {


    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewDidLayoutSubviews() {
        self.ViewLayout()
    }
    
    private func ViewLayout() {
        if(PageLayoutFlag){return}
        PageLayoutFlag = true
    }

}

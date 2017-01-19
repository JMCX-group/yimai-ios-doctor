//
//  PageAddBankcardBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon


class PageAddBankcardBodyView: PageBodyView, UIPickerViewDelegate, UIPickerViewDataSource {
    var AddActions: PageAddBankcardActions!
    var BankPicker = UIPickerView()
    let Banklist = [
        "中国银行",
        "中国工商银行",
        "中国建设银行",
        "中国农业银行",
        "招商银行",
        "中国邮政储蓄银行",
        "中国光大银行",
        "中信银行",
        "交通银行",
        "兴业银行",
        "浦发银行",
        "华夏银行",
        "深圳发展银行",
        "广东发展银行",
        "中国民生银行",
        "北京银行",
        "平安银行",
        "上海银行"
    ]
    
    var SubBankNameInput: YMTextField!
    var BankCardInput: YMTextField!
    
    override func ViewLayout() {
        super.ViewLayout()

        AddActions = PageAddBankcardActions(navController: NavController!, target: self)
        DrawBankPicker()

        let param = TextFieldCreateParam()
        param.FontSize = 30.LayoutVal()
        param.FontColor = YMColors.FontGray
        param.Placholder = "请输入具体开户行名称"

        SubBankNameInput = YMLayout.GetTextField(param)

        param.Placholder = "请输入银行卡号"
        BankCardInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 19)
        BankCardInput.keyboardType = UIKeyboardType.NumberPad

        BodyView.addSubview(SubBankNameInput)
        BodyView.addSubview(BankCardInput)

        SubBankNameInput.align(Align.UnderMatchingLeft, relativeTo: BankPicker, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        BankCardInput.align(Align.UnderMatchingLeft, relativeTo: SubBankNameInput, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        SubBankNameInput.SetBothPaddingWidth(40.LayoutVal())
        BankCardInput.SetBothPaddingWidth(40.LayoutVal())
        
        DrawBottom()
    }
    
    func DrawBottom() {
        let submit = YMButton()
        
        submit.setTitle("添加", forState: UIControlState.Normal)
        submit.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        submit.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        submit.backgroundColor = YMColors.CommonBottomBlue
        
        submit.addTarget(AddActions, action: "SubmitTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ParentView?.addSubview(submit)
        submit.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
    }
    
    func DrawBankPicker() {
        BankPicker.delegate = self
        BankPicker.dataSource = self
        
        BodyView.addSubview(BankPicker)
        BankPicker.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 300.LayoutVal())
    }
    
    func SetSelectedBank() {
        
    }

    func VerifyInput() -> String? {
        let subBank = SubBankNameInput.text!
        if(subBank.characters.count < 4) {
            return "请输入正确的开户行信息"
        }

        let card = BankCardInput.text!
//        if(card.characters.count)
        if(!YMValueValidator.IsBankCard(card)) {
            return "请输入正确的银行卡号"
        }

        return nil
    }
    
    func GetInfo() -> [String: AnyObject] {
        let subBank = SubBankNameInput.text!
        let card = BankCardInput.text!
        
        let selectedBankIdx = BankPicker.selectedRowInComponent(0)

        return [
            "name": Banklist[selectedBankIdx],
            "info": subBank,
            "no": card,
            "desc": ""
        ]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Banklist.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Banklist[row]
    }

    func ClearBody() {
        BankPicker.selectRow(0, inComponent: 0, animated: true)
        SubBankNameInput?.text = ""
        BankCardInput?.text = ""
    }
}

































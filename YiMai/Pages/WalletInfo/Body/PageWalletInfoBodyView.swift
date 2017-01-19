//
//  PageWalletInfoBodyView.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Charts
import ChameleonFramework

class BankPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var BankData: [[String: AnyObject]]!
    
    var Panel: YMTouchableView!
    let ButtonPanel = UIView()
    
    let Picker = UIPickerView()
    let ConfirmBtn = YMButton()
    let CancelBtn = YMButton()
    
    var Actions: PageWalletInfoActions!
    

    init(parent: UIView, action: PageWalletInfoActions, data: [[String: AnyObject]]) {
        super.init()
        BankData = data
        Actions = action
        DrawPanel(parent)

        Picker.delegate = self
        Picker.dataSource = self
        
    }
    
    func Show() {
        Panel.hidden = false
    }
    
    func HidePicker(_: AnyObject) {
        Panel.hidden = true
    }
    
    func BankSelected(_: AnyObject) {
        let selectedRow = Picker.selectedRowInComponent(0)
        Actions.DoCashOut(BankData[selectedRow])
    }
    
    func DrawButton(btn: YMButton, title: String, color: UIColor, sel: Selector) {
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(color, forState: UIControlState.Normal)
        btn.sizeToFit()
        btn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        
        btn.addTarget(self, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func DrawPanel(parent: UIView) {
        Panel = YMLayout.GetTouchableView(useObject: self, useMethod: "HidePicker:".Sel())
        Panel.backgroundColor = YMColors.OpacityBlackMask
        Panel.hidden = true
        
        parent.addSubview(Panel)
        Panel.fillSuperview()
        
        Panel.addSubview(ButtonPanel)
        Panel.addSubview(Picker)
        
        ButtonPanel.addSubview(CancelBtn)
        ButtonPanel.addSubview(ConfirmBtn)
        
        Picker.backgroundColor = YMColors.PanelBackgroundGray
        ButtonPanel.backgroundColor = YMColors.BackgroundGray
        
        Picker.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.PageHeight / 3)
        ButtonPanel.align(Align.AboveMatchingLeft, relativeTo: Picker, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        
        DrawButton(ConfirmBtn, title: "确定", color: YMColors.FontBlue, sel: "BankSelected:".Sel())
        DrawButton(CancelBtn, title: "取消", color: YMColors.FontBlue, sel: "HidePicker:".Sel())
        
        ConfirmBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: CancelBtn.width, height: 60.LayoutVal())
        CancelBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: CancelBtn.width, height: 60.LayoutVal())
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let bankInfo = BankData[row]
        let cardNum = YMVar.GetStringByKey(bankInfo, key: "no")
        let bankName = YMVar.GetStringByKey(bankInfo, key: "name")
        
        let lastIdx = cardNum.startIndex.advancedBy(cardNum.characters.count - 5)
        let ret = "\(bankName) 尾号：\(cardNum.substringFromIndex(lastIdx))"
        
        return ret
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BankData?.count ?? 0
    }
    
    func Dispose() {
        Panel.hidden = true
        Panel.removeFromSuperview()
        Actions = nil
        BankData = nil
    }
}

class PageWalletInfoBodyView: PageBodyView {
    var WalletActions: PageWalletInfoActions!
    let BalancePanel = UIView()
    let BalanceDetailPanel = UIView()
    let PiePanel = UIView()
    let DetailButton = YMButton()
    
    var Bank: BankPicker?
    
    let CashOutButton = YMButton()

    override func ViewLayout() {
        super.ViewLayout()
        
        WalletActions = PageWalletInfoActions(navController: self.NavController!, target: self)
        
        DrawFullBody()
        DrawCashOutButton()
    }
    
    func DrawFullBody() {
        BodyView.addSubview(BalancePanel)
        BodyView.addSubview(BalanceDetailPanel)
        BodyView.addSubview(PiePanel)
        
        BalancePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 240.LayoutVal())
        BalanceDetailPanel.align(Align.UnderMatchingLeft, relativeTo: BalancePanel, padding: 0, width: YMSizes.PageWidth, height: 256.LayoutVal())
        PiePanel.align(Align.UnderMatchingLeft, relativeTo: BalanceDetailPanel, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 500.LayoutVal())
    }
    
    func DrawCashOutButton() {
        CashOutButton.setTitle("申请提现", forState: UIControlState.Normal)
        CashOutButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        CashOutButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        CashOutButton.backgroundColor = YMColors.CommonBottomBlue

        ParentView?.addSubview(CashOutButton)
        CashOutButton.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        CashOutButton.addTarget(WalletActions, action: "CashOutTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func EnableCashOut() {
        CashOutButton.enabled = true
        CashOutButton.backgroundColor = YMColors.CommonBottomBlue
    }
    
    func DisableCashOut() {
        CashOutButton.enabled = false
        CashOutButton.backgroundColor = YMColors.CommonBottomGray
    }
    
    func DrawRecordButton(topPanel: UIView) {
        topPanel.addSubview(DetailButton)
        DetailButton.setTitle("收支明细", forState: UIControlState.Normal)
        DetailButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        DetailButton.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        DetailButton.sizeToFit()
        DetailButton.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: DetailButton.width, height: DetailButton.height)
        
        DetailButton.addTarget(WalletActions, action: "ShowCashDetail:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func LoadData(data: [String: AnyObject]) {
        YMLayout.ClearView(view: BalancePanel)
        YMLayout.ClearView(view: BalanceDetailPanel)
        YMLayout.ClearView(view: PiePanel)

        DrawBalancePanel(data)
        DrawBalanceDetailPanel(data)
        DrawPiePanel(data)

        FullPageLoading.Hide()
    }
    
    func Clear() {
        DisableCashOut()
        Bank?.Dispose()
        YMLayout.ClearView(view: BalancePanel)
        YMLayout.ClearView(view: BalanceDetailPanel)
        YMLayout.ClearView(view: PiePanel)
    }
    
    func DrawBalancePanel(data: [String: AnyObject]) {
        let total = YMVar.GetStringByKey(data, key: "total")
        let totalLabel = YMLayout.GetNomalLabel(total, textColor: YMColors.FontGray, fontSize: 90.LayoutVal())
        let totalTitle = YMLayout.GetNomalLabel("总余额（元）", textColor: YMColors.FontBlue, fontSize: 26.LayoutVal())
        
        if("0" == total) {
            DetailButton.hidden = true
        } else {
            DetailButton.hidden = false
        }
        
        BalancePanel.addSubview(totalLabel)
        BalancePanel.addSubview(totalTitle)
        totalLabel.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: totalLabel.width, height: totalLabel.height)
        totalTitle.align(Align.UnderCentered, relativeTo: totalLabel, padding: 20.LayoutVal(), width: totalTitle.width, height: totalTitle.height)
    }
    
    func DrawBalanceDetailPanel(data: [String: AnyObject]) {
        //        "data": {
        //            "total": "总额",
        //            "billable": "可提现",
        //            "pending": "待结算",
        //            "refunded": "已提现"
        //        }
        
        let billableCell = YMLayout.GetTouchableView(useObject: WalletActions, useMethod: PageJumpActions.DoNothingSel)
        let pendingCell = YMLayout.GetTouchableView(useObject: WalletActions, useMethod: PageJumpActions.DoNothingSel)
        
        BalanceDetailPanel.addSubview(billableCell)
        BalanceDetailPanel.addSubview(pendingCell)
        
        BalanceDetailPanel.groupAndFill(group: Group.Horizontal, views: [billableCell, pendingCell], padding: 0)

        let billable = YMVar.GetStringByKey(data, key: "billable")
        let billableTitle = YMLayout.GetNomalLabel("可提现（元）", textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        let billableLabel = YMLayout.GetNomalLabel(billable, textColor: YMColors.FontGray, fontSize: 60.LayoutVal())
        
        billableCell.addSubview(billableTitle)
        billableCell.addSubview(billableLabel)
        
        billableTitle.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: billableTitle.width, height: billableTitle.height)
        billableLabel.align(Align.UnderCentered, relativeTo: billableTitle, padding: 20.LayoutVal(), width: billableLabel.width, height: billableLabel.height)
        
        
        let pending = YMVar.GetStringByKey(data, key: "pending")
        let pendingTitle = YMLayout.GetNomalLabel("待结算（元）", textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        let pendingLabel = YMLayout.GetNomalLabel(pending, textColor: YMColors.FontGray, fontSize: 60.LayoutVal())
        
        pendingCell.addSubview(pendingTitle)
        pendingCell.addSubview(pendingLabel)
        
        pendingTitle.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: pendingTitle.width, height: pendingTitle.height)
        pendingLabel.align(Align.UnderCentered, relativeTo: pendingTitle, padding: 20.LayoutVal(), width: pendingLabel.width, height: pendingLabel.height)

        let divider = UIView()
        divider.backgroundColor = YMColors.FontLightGray
        BalanceDetailPanel.addSubview(divider)
        divider.anchorInCenter(width: 1, height: 176.LayoutVal())
    }
    
    func DrawPiePanel(data: [String: AnyObject]) {
        let pieChart = PieChartView()
//        let pieDataSet = PieChartDataSet()
        
        PiePanel.addSubview(pieChart)
        pieChart.fillSuperview()
        
        let billableStr = YMVar.GetStringByKey(data, key: "billable")
        let pendingStr = YMVar.GetStringByKey(data, key: "pending")
        let totalStr = YMVar.GetStringByKey(data, key: "total")
    
        let billable = billableStr.DoubleVal
        var pending = pendingStr.DoubleVal
        
        if(billable > 0.001) {
            DisableCashOut()
        } else {
            EnableCashOut()
        }

        if("0" == billableStr && "0" == pendingStr) {
            pending = totalStr.DoubleVal
        }
        
        var pieDataArr = [ChartDataEntry]()
        
        pieDataArr.append(ChartDataEntry(value: pending, xIndex: 0))
        pieDataArr.append(ChartDataEntry(value: billable, xIndex: 0))

//        if((billable / pending) * 100 < 1.0){
//            pieDataArr.append(ChartDataEntry(value: pending, xIndex: 0))
//        } else if((pending / billable) * 100 < 1.0) {
//            pieDataArr.append(ChartDataEntry(value: billable, xIndex: 0))
//        } else {
//            pieDataArr.append(ChartDataEntry(value: pending, xIndex: 0))
//            pieDataArr.append(ChartDataEntry(value: billable, xIndex: 0))
//        }

        let pieDataSet = PieChartDataSet(yVals: pieDataArr, label: "")
        let pieData = PieChartData(xVals: ["待结算", "可提取"], dataSet: pieDataSet)
        
        pieDataSet.highlightEnabled = false
        pieDataSet.drawValuesEnabled = true
        pieDataSet.colors = [YMColors.FontGray, YMColors.FontBlue]
        
        pieChart.data = pieData
        
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 2
        fmt.multiplier = 1.0
        fmt.percentSymbol = "%"
        fmt.usesGroupingSeparator = true
        fmt.groupingSeparator = "."
        fmt.numberStyle = NSNumberFormatterStyle.PercentStyle
        
        pieDataSet.valueFormatter = fmt
        
        pieChart.centerText = "总余额"
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        pieChart.descriptionText = ""
        pieChart.holeRadiusPercent = 0.4
        pieChart.transparentCircleRadiusPercent = 0.45
    }
    
    func ShowBankPicker(data: [[String : AnyObject]]) {
        Bank?.Dispose()
        Bank = nil
        Bank = BankPicker(parent: ParentView!, action: WalletActions!, data: data)
        Bank?.Show()
    }
}








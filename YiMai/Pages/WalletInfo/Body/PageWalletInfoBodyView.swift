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

class PageWalletInfoBodyView: PageBodyView {
    var WalletActions: PageWalletInfoActions!
    let BalancePanel = UIView()
    let BalanceDetailPanel = UIView()
    let PiePanel = UIView()
    let DetailButton = YMButton()

    override func ViewLayout() {
        super.ViewLayout()
        
        WalletActions = PageWalletInfoActions(navController: self.NavController!, target: self)
        
        DrawFullBody()
    }
    
    func DrawFullBody() {
        BodyView.addSubview(BalancePanel)
        BodyView.addSubview(BalanceDetailPanel)
        BodyView.addSubview(PiePanel)
        
        BalancePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 240.LayoutVal())
        BalanceDetailPanel.align(Align.UnderMatchingLeft, relativeTo: BalancePanel, padding: 0, width: YMSizes.PageWidth, height: 256.LayoutVal())
        PiePanel.align(Align.UnderMatchingLeft, relativeTo: BalanceDetailPanel, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 500.LayoutVal())
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
}








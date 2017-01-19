//
//  PageWalletRecordBodyView.swift
//  YiMai
//
//  Created by old-king on 16/11/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageWalletRecordBodyView: PageBodyView {
    var RecordActions: PageWalletRecordActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        RecordActions = PageWalletRecordActions(navController: self.NavController!, target: self)
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: BodyView)
        let title = DrawTitle()
        DrawList(data, titlePanel: title)
        
        FullPageLoading.Hide()
    }
    
    func DrawTitle() -> UIView {
        let titleLabel = YMLayout.GetNomalLabel("结算日为每个月的自然日20日", textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        let titlePanel = UIView()
        
        titlePanel.backgroundColor = YMColors.BackgroundGray
        
        BodyView.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        return titlePanel
    }
    
    func DrawCell(entry: [String: AnyObject], parent: UIView, prev: UIView? = nil) -> UIView {
//        "id": "ID",
//        "name": "名目名称",
//        "transaction_id": "交易单号/预约号",
//        "price": "价格",
//        "type": "类型：收入/支出",
//        "status": "状态：还没想好怎么用，先传前台去",
//        "time": "交易发生时间"
        
        let cell = UIView()
        parent.addSubview(cell)
        cell.backgroundColor = YMColors.White
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        }
        
        let type = YMVar.GetStringByKey(entry, key: "type", defStr: "收入")
        let price = YMVar.GetStringByKey(entry, key: "price")

//        if("收入" == type) {
//            price = "+ " + price
//        } else {
//            type = "支出"
//            price = "- " + price
//        }
        
        let typeLabel = YMLayout.GetNomalLabel(type, textColor: YMColors.FontGray, fontSize: 30.LayoutVal())
        let priceLabel = YMLayout.GetNomalLabel(price, textColor: YMColors.FontBlue, fontSize: 34.LayoutVal())
        
        let name = YMVar.GetStringByKey(entry, key: "name")
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.FontBlue, fontSize: 34.LayoutVal())
    
        let time = YMVar.GetStringByKey(entry, key: "time")
        let timeLabel = YMLayout.GetNomalLabel(time, textColor: YMColors.FontLightGray, fontSize: 24.LayoutVal())
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = YMColors.DividerLineGray
        
        cell.addSubview(typeLabel)
        cell.addSubview(priceLabel)
        cell.addSubview(nameLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(bottomBorder)
        
        typeLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: typeLabel.width, height: typeLabel.height)
        nameLabel.align(Align.UnderMatchingLeft, relativeTo: typeLabel, padding: 30.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        
        timeLabel.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        priceLabel.align(Align.UnderMatchingLeft, relativeTo: timeLabel, padding: 30.LayoutVal(), width: priceLabel.width, height: priceLabel.height)
        
        bottomBorder.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        return cell
    }
    
    func DrawList(data: [[String: AnyObject]], titlePanel: UIView) {
        var prev = titlePanel
        for entry in data {
            prev = DrawCell(entry, parent: BodyView, prev: prev)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev)
    }
}








//
//  PageBankCardListBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon


class PageBankCardListBodyView: PageBodyView {
    var ListActions: PageBankCardListActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ListActions = PageBankCardListActions(navController: NavController!, target: self)
    }
    
    func DrawFullBody(data: [[String: AnyObject]]?) {
        YMLayout.ClearView(view: BodyView)
        
        var prev: UIView? = nil
        if(nil != data) {
            for card in data! {
                prev = DrawCardCell(card, prev: prev)
            }
        }

        DrawAddCell(prev)
    }
    
    func DrawAddCell(prev: UIView?) {
        let addText = YMLayout.GetTouchableView(useObject: ListActions, useMethod: "AddCardTouched:".Sel())
        BodyView.addSubview(addText)
        
        if(nil == prev) {
            addText.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        } else {
            addText.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: addText)
        
        let icon = YMLayout.GetSuitableImageView("YMIconAddCommonText")
        let text = YMLayout.GetNomalLabel("添加银行卡", textColor: YMColors.FontBlue, fontSize: 28.LayoutVal())
        
        addText.addSubview(icon)
        addText.addSubview(text)
        
        icon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
        text.align(Align.ToTheRightCentered, relativeTo: icon, padding: 20.LayoutVal(), width: text.width, height: text.height)
    }
    
    func DrawCardCell(card: [String: AnyObject], prev: UIView?) -> UIView? {
        let cardNum = YMVar.GetStringByKey(card, key: "no")
        let bankName = YMVar.GetStringByKey(card, key: "name")
        
        if(YMValueValidator.IsBlankString(cardNum)) {
            return prev
        }
        
        if(cardNum.characters.count != 19 && cardNum.characters.count != 16) {
            return prev
        }
        
        let cell = YMLayout.GetScrollCell(useObject: ListActions, useMethod: PageJumpActions.DoNothingSel)

        BodyView.addSubview(cell)
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        }

        let lastIdx = cardNum.startIndex.advancedBy(cardNum.characters.count - 5)
        let cardLabel = YMLayout.GetNomalLabel(" 尾号：\(cardNum.substringFromIndex(lastIdx))", textColor: YMColors.FontLightGray, fontSize: 24.LayoutVal())
        let bankLabel = YMLayout.GetNomalLabel(bankName, textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        
        cell.addSubview(cardLabel)
        cell.addSubview(bankLabel)
        
        bankLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: bankLabel.width, height: bankLabel.height)
        cardLabel.align(Align.ToTheRightCentered, relativeTo: bankLabel, padding: 10.LayoutVal(), width: cardLabel.width, height: bankLabel.height)
        cell.UserStringData = YMVar.GetStringByKey(card, key: "id")
        cell.SetCellBtn("删除", titleColor: YMColors.White, bkgColor: UIColor.redColor(), fontSize: 40.LayoutVal(), padding: 40.LayoutVal()) { (str, obj) in
            self.FullPageLoading.Show()
            self.ListActions.DelApi.YMDelBankcard(str!)
        }
        
        return cell
    }
}




























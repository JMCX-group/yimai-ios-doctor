//
//  PageYiMaiR1BodyView.swift
//  YiMai
//
//  Created by why on 16/5/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiR1BodyView: PageBodyView {
    private var SearchInput: YMTextField? = nil
    private var SameHopitalButton: YMTouchableView? = nil
    private var SameSchoolButton: YMTouchableView? = nil
    private var SameAreasButton: YMTouchableView? = nil
    
    private let SearchPanel = UIView()
    private let OperationPanel = UIView()
    
    private let OperationSelector:Selector = "PageJumpToByViewSender:"

    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        
        DrawSearchPanel()
        DrawOptPanel()
    }
    
    private func DrawOptPanel() {
        BodyView.addSubview(OperationPanel)
        
        OperationPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, height: 200.LayoutVal())
        
        func BuildOpertorCell(cell: YMTouchableView, imageName: String, targetPage: String, title: String, count: String?) {
            let icon = YMLayout.GetSuitableImageView(imageName)
            let titleLabel = UILabel()
            
            
            cell.addSubview(icon)
            cell.addSubview(titleLabel)
            
            icon.anchorToEdge(Edge.Top, padding: 0, width: icon.width, height: icon.height)
            titleLabel.alignAndFillWidth(align: Align.UnderCentered, relativeTo: icon, padding: -100.LayoutVal(), height: 30.LayoutVal())
            
            titleLabel.text = title
            titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
            titleLabel.textColor = YMColors.FontBlue
            titleLabel.textAlignment = NSTextAlignment.Center
            
            
            if(nil != count && "" != count) {
                let countLabel = UILabel()
                cell.addSubview(countLabel)
                
                countLabel.text = count
                countLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
                countLabel.textColor = YMColors.FontGray
                countLabel.textAlignment = NSTextAlignment.Center
                countLabel.backgroundColor = YMColors.BackgroundGray
                countLabel.sizeToFit()
                
                countLabel.align(Align.UnderCentered, relativeTo: titleLabel, padding: 18.LayoutVal(), width: countLabel.width+40.LayoutVal(), height: 28.LayoutVal())
            }
            
        }
        
        SameHopitalButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector)
        SameSchoolButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector)
        SameAreasButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector)
        
        OperationPanel.addSubview(SameHopitalButton!)
        OperationPanel.addSubview(SameAreasButton!)
        OperationPanel.addSubview(SameSchoolButton!)

        OperationPanel.groupAndFill(group: Group.Horizontal, views: [SameHopitalButton!, SameAreasButton!, SameSchoolButton!], padding: 1)
        
        BuildOpertorCell(SameHopitalButton!, imageName: "YiMaiR1SameHospital", targetPage: "", title: "同医院", count: "10人")
        BuildOpertorCell(SameAreasButton!, imageName: "YiMaiR1SameAreas", targetPage: "", title: "同领域", count: "17人")
        BuildOpertorCell(SameSchoolButton!, imageName: "YiMaiR1SameSchool", targetPage: "", title: "同学校", count: "9人")
    }

    private func DrawSearchPanel() {
        let searchInputParam = TextFieldCreateParam()
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")

        searchInputParam.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        searchInputParam.Placholder = YMYiMaiStrings.CS_SEARCH_PLACEHOLDER
        searchInputParam.FontSize = 26.LayoutVal()
        searchInputParam.FontColor = YMColors.FontBlue

        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(searchInputParam, maxCharCount: 60)
        
        BodyView.addSubview(SearchPanel)
        SearchPanel.addSubview(SearchInput!)
        
        SearchPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 120.LayoutVal())

        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        SearchInput?.SetLeftPadding(searchIconView)
    }
}
//
//  PagePersonalDetailBodyView.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalDetailBodyView: NSObject {
    private var Parent: UIView? = nil
    public let BodyView = UIScrollView()
    private var Actions: PagePersonalDetailActions? = nil
    
    public let TagPanel = YMTouchableView()
    private let CommonFriendPanel = UIView()
    public let IntroductionPanel = UIView()
    private let SchoolPanel = UIView()
    
    private var TagExpandArrow: YMTouchableImageView? = nil
    private var TagCollapseArrow: YMTouchableImageView? = nil
    
    private let IntroLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 690.LayoutVal(), height: 0))
    private let SchoolLabel = UILabel()

    init(parent: UIView, actions: PagePersonalDetailActions) {
        super.init()
        self.Parent = parent
        self.Actions = actions
        
        ViewLayout()
    }
    
    private func ViewLayout() {
        Parent?.addSubview(BodyView)
        BodyView.fillSuperview()
        BodyView.contentInset = UIEdgeInsets(top: 512.LayoutVal(), left: 0, bottom: 0, right: 0)
        BodyView.backgroundColor = YMColors.BackgroundGray
    }
    
    public func LoadData(data: [String: AnyObject]) {
        let tags = data["tags"] as? String
        if(!YMValueValidator.IsEmptyString(tags)) {
            DrawTagPanel(tags!)
        }
        
        var introPanelAlignTo: UIView? = nil

        if(PagePersonalDetailViewController.DoctorId == YMVar.MyDoctorId) {
            introPanelAlignTo = TagPanel
        } else {
//            introPanelAlignTo = CommonFriendPanel
            introPanelAlignTo = TagPanel
        }

        let intro = data["personal_introduction"] as? String
        if(!YMValueValidator.IsEmptyString(intro)) {
            DrawDoctorIntroduction(intro!, alignView: introPanelAlignTo!)
        }
        
        let school = data["college"] as? [String: AnyObject]
        if(nil != school) {
            DrawSchool(school!["name"]! as! String)
        }
    }
    
    private func DrawTagPanel(tags: String) {
        BodyView.addSubview(TagPanel)
        TagPanel.anchorToEdge(Edge.Top, padding: 20.LayoutVal(), width: YMSizes.PageWidth, height: 130.LayoutVal())
        TagPanel.backgroundColor = YMColors.White
        TagPanel.layer.masksToBounds = true
        
        let title = UILabel()
        title.text = "特长"
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        TagPanel.addSubview(title)
        title.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: title.width, height: title.height)
        
        let lastLine = DrawTagList(tags, tagTitle: title)
        if(nil != lastLine) {
            YMLayout.SetViewHeightByLastSubview(TagPanel, lastSubView: lastLine!)
        }
//        TagExpandArrow = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "TagPanelExpand:".Sel(), imageName: "PagePersonalDetailArrowDownIcon")
//        TagCollapseArrow = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "TagPanelCollapse:".Sel(), imageName: "PagePersonalDetailArrowUpIcon")
    }
    
    private func GetTagLabel(tagText: String) -> UILabel {
        let tag = UILabel()

        tag.text = tagText
        tag.font = YMFonts.YMDefaultFont(26.LayoutVal())
        tag.textAlignment = NSTextAlignment.Center
        tag.textColor = YMColors.FontGray
        tag.layer.cornerRadius = 6.LayoutVal()
        tag.layer.masksToBounds = true
        tag.sizeToFit()

        tag.layer.borderColor = YMColors.FontGray.CGColor
        tag.layer.borderWidth = 1

        return tag
    }

    private func DrawTagList(tags: String, tagTitle: UIView) -> UIView? {
        func GetTagFullWidth(tagLabel: UILabel) -> CGFloat{
            return tagLabel.width + 50.LayoutVal()
        }

        let tagArray = tags.componentsSeparatedByString(",")
        
        var labelArray = [UILabel]()
        var widthArray = [CGFloat]()
        var lineArray = [[Int]]()
        var lineViewArray = [UIView]()

        let listLineWidth = 610.LayoutVal()
        let listLineHeight = 42.LayoutVal()
        
        if(0 == tagArray.count) {
            return nil
        }

        let tagSorted = tagArray.sort { (a, b) -> Bool in
            return a.characters.count > b.characters.count
        }
        
        for tag in tagSorted {
            if (YMValueValidator.IsEmptyString(tag)) {
                continue
            }
            let tagLabel = GetTagLabel(tag)
            labelArray.append(tagLabel)
            widthArray.append(GetTagFullWidth(tagLabel))
        }
        
        for (idx, val) in widthArray.enumerate() {
            var newLineFlag = true
            
            for (lIdx, lVal) in lineArray.enumerate() {
                var allTagWidth:CGFloat = 0
                for tagIdx in lVal {
                    allTagWidth += widthArray[tagIdx]
                }
                
                if((allTagWidth + val) < listLineWidth) {
                    newLineFlag = false
                    lineArray[lIdx].append(idx)
                }
            }
            
            if(newLineFlag) {
                var newLine = [Int]()
                newLine.append(idx)
                lineArray.append(newLine)
            }
        }

        var lastLine: UIView? = nil
        for (lIdx, lVal) in lineArray.enumerate() {
            let lineView = UIView()
            lastLine = lineView
            lineViewArray.append(lineView)
            TagPanel.addSubview(lineView)
            if(0 == lIdx) {
                lineView.anchorInCorner(Corner.TopLeft, xPad: 120.LayoutVal(), yPad: 20.LayoutVal(), width: listLineWidth, height: listLineHeight)
            } else {
                let prevLine = lineViewArray[lIdx - 1]
                lineView.align(Align.UnderMatchingLeft, relativeTo: prevLine, padding: 10.LayoutVal(), width: listLineWidth, height: listLineHeight)
            }

            var prevLabel: UILabel? = nil
            for (idx, val) in lVal.enumerate() {
                let tagLabel = labelArray[val]
                lineView.addSubview(tagLabel)
                if(0 == idx) {
                    tagLabel.anchorToEdge(Edge.Left, padding: 0, width: widthArray[val] - 10.LayoutVal(), height: listLineHeight)
                } else {
                    tagLabel.align(Align.ToTheRightCentered, relativeTo: prevLabel!, padding: 10.LayoutVal(), width: widthArray[val] - 10.LayoutVal(), height: listLineHeight)
                }
                prevLabel = tagLabel
            }
        }

        return lastLine!
    }
    
    private func DrawDoctorIntroduction(info: String, alignView: UIView) {
        BodyView.addSubview(IntroductionPanel)
        IntroductionPanel.backgroundColor = YMColors.White
        
        let title = UILabel()
        title.text = "医生简介"
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        IntroductionPanel.addSubview(title)
        
        IntroLabel.text = info
        IntroLabel.textColor = YMColors.FontGray
        IntroLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        IntroLabel.numberOfLines = 0
        IntroLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        IntroLabel.preferredMaxLayoutWidth = 690.LayoutVal()
        IntroLabel.sizeToFit()
        
        IntroductionPanel.addSubview(IntroLabel)
        IntroductionPanel.align(Align.UnderMatchingLeft, relativeTo: alignView, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: IntroLabel.height + 90.LayoutVal())
        
        title.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: title.width, height: title.height)
        IntroLabel.align(Align.UnderMatchingLeft, relativeTo: title, padding: 20.LayoutVal(), width: IntroLabel.width, height: IntroLabel.height)
    }
    
    private func DrawSchool(school: String) {
        BodyView.addSubview(SchoolPanel)
        SchoolPanel.align(Align.UnderMatchingLeft, relativeTo: IntroductionPanel, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 68.LayoutVal())
        SchoolPanel.backgroundColor = YMColors.White
        
        let title = UILabel()
        title.text = "毕业院校"
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        SchoolPanel.addSubview(title)
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        
        SchoolPanel.addSubview(SchoolLabel)
        SchoolLabel.text = school
        SchoolLabel.textColor = YMColors.FontGray
        SchoolLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SchoolLabel.sizeToFit()

        SchoolLabel.align(Align.ToTheRightCentered, relativeTo: title, padding: 20.LayoutVal(), width: SchoolLabel.width, height: SchoolLabel.height)
    }
}


























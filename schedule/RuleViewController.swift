//
//  RuleViewController.swift
//  
//
//  Created by 陳彥甫 on 2020/8/13.
//

import UIKit

class RuleViewController: UIViewController {
    
    var backButton = UIButton()
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取消向下滑動返回&&全螢幕
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
        let ruleTitle = "領養須知"
        let ruleText = "領養條件:\n必須年滿20歲之民眾。未滿20歲者，以其法定代理人或法定監護人為飼主。如果是男生，必須服完兵役唷！\n\n\n\n認養6步驟：\n1、與狗狗第一次接觸 - 參訪犬舍，從候選狗卡中挑選速配的狗狗，與候選狗狗初次相遇。\n2、填寫申請書 - 詢問櫃台服務人員，並填寫認養申請書。\n3、核對相關證件 - 核對申請書及身份證件，並繳交費用。\n4、狗狗健康檢查 - 獸醫師進行健康檢查，並實施晶片植入、狂犬病預防注射及辦理寵物登記。\n5、諮詢協助服務 - 接受櫃台服務人員認養前諮詢及提供協助管道，必要時派員實施家庭訪問。\n6、帶新朋友回家 - 帶狗狗回家，戴上新項圈及牽繩，您現在就可以帶新朋友回家。\n"
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:screenWidth,height: 50))
        titleLabel.center = CGPoint(x: screenWidth/2, y: 100)
        titleLabel.font = UIFont(name:"Helvetica-Light", size: 50)
        titleLabel.textAlignment = .center
        titleLabel.text = ruleTitle
        self.view.addSubview(titleLabel)
        
        backButton = UIButton(frame: CGRect(x: screenWidth - 50, y: 50 , width: 30, height: 30))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        self.view.backgroundColor = .white
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 150, width: screenWidth, height: screenHeight - 150))
        // 實際視圖範圍
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 2)
        // 是否顯示垂直的滑動條
        scrollView.showsVerticalScrollIndicator = true
        // 滑動條的樣式
        scrollView.indicatorStyle = .black
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 50, width: screenWidth - 100, height: screenHeight - 200))
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 50
        textLabel.text = ruleText
        scrollView.addSubview(textLabel)
        
        scrollView.backgroundColor = .gray
        self.view.addSubview(scrollView)
        
    }
    
    
    
    @objc func back(){
        self.dismiss(animated: false, completion: nil)
    }

    
    
    
    
    
    
}

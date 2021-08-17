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
        var ruleText = "領養條件:\n必須年滿20歲之民眾。未滿20歲者，以其法定代理人或法定監護人為飼主。如果是男生，必須服完兵役唷！\n\n\n認養6步驟：\n1、與狗狗第一次接觸 - 參訪犬舍，從候選狗卡中挑選速配的狗狗，與候選狗狗初次相遇。\n2、填寫申請書 - 詢問櫃台服務人員，並填寫認養申請書。\n3、核對相關證件 - 核對申請書及身份證件，並繳交費用。\n4、狗狗健康檢查 - 獸醫師進行健康檢查，並實施晶片植入、狂犬病預防注射及辦理寵物登記。\n5、諮詢協助服務 - 接受櫃台服務人員認養前諮詢及提供協助管道，必要時派員實施家庭訪問。\n6、帶新朋友回家 - 帶狗狗回家，戴上新項圈及牽繩，您現在就可以帶新朋友回家。\n\n\n申請步驟:\n1、申請人應攜身分證明文件，填具申請書。\n2、承辦人員應就認養人核對身分證明文件，必要時得親自實地勘察。\n3、待認養動物條件：於本處留置已逾7日尚無飼主認領或無身分標識者，且經本處健康行為評估適於認養者。\n4、符合認養人資格者，得由管理人員協助，由可認養犬隻中，自行挑選合意犬隻。\n5、繳交相關規費：晶片植入手續費250元、狂犬病預防注射費200元。\n6、未實施晶片植入、狂犬病預防注射及寵物登記之動物，應於完成晶片植入、狂犬病預防注射及寵物登記後始得放行。唯8週齡以下幼犬暫免施打狂犬病疫苗。\n7、認養之犬隻自領出日起1個月內，若因任何原因無法續養，可將該犬交還本所，填寫「不擬續養動物申請切結書」放棄該犬之所有權，並繳回寵物登記證及狂犬病預防注射證明辦理註銷。認養時所繳之費用概不退還。\n\n\n疫苗須知：\n1、狂犬病疫苗 : 注射費用含疫苗200元，每年施打一次。\n2、八合一疫苗 : 注射費用含疫苗800~1000元左右，而綜合預防針最早是在幼犬每四周打一次（一個月一劑），連續三次，之後終身每年一次。\n\n\n狂犬病小知識：\n狂犬病是病原是病毒，是一種可以感染任何溫血動物的人畜共通傳染病。主要經由感染動物咬傷而從其唾液傳播。發病時會出現行為改變、不安、攻擊、流口水、吞嚥困難……等症狀。發病後無法醫治，只能用疫苗預防。非疫區的國家是屬於非核心疫苗，但台灣在2013年再度成為疫區，因此所有狗狗都必須施打狂犬病疫苗。"
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:screenWidth,height: 50))
        titleLabel.center = CGPoint(x: screenWidth/2, y: 100)
        titleLabel.font = UIFont(name:"Helvetica-Light", size: 50)
        titleLabel.textAlignment = .center
        titleLabel.text = ruleTitle
        self.view.addSubview(titleLabel)
        
        backButton = UIButton(frame: CGRect(x: 50, y: 20 , width: 30, height: 30))
        backButton.setImage(UIImage(named: "cancel"), for: .normal)
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
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 50, width: screenWidth - 100, height: screenHeight * 2 - 100))
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "Arial-BoldMT", size: 15)
        textLabel.numberOfLines = 100
        //取得textlabel總共行數 讓textLabel靠到最上方
        let lineCount = Int(textLabel.frame.height / textLabel.font.lineHeight)
        for _ in 70...lineCount {
            ruleText += "\n"
        }
        textLabel.text = ruleText
        scrollView.addSubview(textLabel)
        
        scrollView.backgroundColor = defultColor
        self.view.addSubview(scrollView)
        
    }
    
    
    
    @objc func back(){
        self.dismiss(animated: false, completion: nil)
    }

    
    
    
    
    
    
}

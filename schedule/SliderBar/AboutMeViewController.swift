//
//  AboutMeViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/2.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    var scrollView = UIScrollView()
    var image = UIImageView()
    var label = UILabel()
    var backBtn = UIButton()
    var text = "現今飼養寵物的民眾越來越多，其中多以貓狗為首要選擇，牠們不僅外表可愛、飼養也方便，但並非每位飼主都能善盡責任，導致棄養事件時有所聞，貓狗流落街頭，間接衍生傳染疾病、環境衛生、貓狗攻擊人群亦或牠們自身的安全問題。\n\n流浪動物對環境影響不光只是牠們的排泄物，還有翻找垃圾桶尋覓食物的痕跡，成群結隊的習性也帶來人身及貓狗自身的安全問題，另外，流浪動物不會過馬路，可能遭車輛撞傷，或是車輛為了躲避撞到流浪動物而摔車、撞車。\n\n希望可以透過這個APP，讓更多流浪貓狗，找到一個屬於牠們的家，最後呼籲大家，請領養代替購買。"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ios13以上全螢幕
        if #available(iOS 13.0, *) {
            self.modalPresentationStyle = .fullScreen
        }
        label = UILabel.init(frame: CGRect(x: 30, y: screenHeight / 3 + 90, width: screenWidth - 60, height: screenHeight))
        label.textAlignment = .left
        label.font = UIFont(name: "Arial-BoldMT", size: 18)
        let lineCount = Int(label.frame.height / label.font.lineHeight)
        for _ in 19...lineCount{
            text += "\n"
        }
        label.text = text
        label.numberOfLines = 44
        

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 1.5)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .black
        scrollView.backgroundColor = defultColor
        
        
        image = UIImageView(frame: CGRect(x: 30, y: 70, width: screenWidth - 60, height: screenHeight / 3))
        image.backgroundColor = .black
        image.image = UIImage(named: "aboutMe")
        scrollView.addSubview(backBtn)
        scrollView.addSubview(image)
        scrollView.addSubview(label)
        self.view.addSubview(scrollView)
        
        BackBtnView.backBtnView.setBtn(superVC: self)
        
    }
    
}

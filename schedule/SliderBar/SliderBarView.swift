//
//  SliderBarView.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/3/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import MessageUI

class SliderBarView: UIViewController,MFMailComposeViewControllerDelegate {
    
    var bgView = UIView()
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
    func setUI(spView:UIView){
        bgView = UIView.init(frame:CGRect(x: spView.frame.width/3 * 2, y: 0, width: spView.frame.width/3, height: spView.frame.height))
        bgView.backgroundColor = .white
        bgView.alpha = 0.7
        self.view.frame.size.height = screenHeight
        self.view.frame.size.width = screenWidth/3 * 2
        self.view.frame.origin = screenOrigin
        self.view.backgroundColor = .lightGray
        
        spView.addSubview(bgView)
        spView.addSubview(self.view)
        bgView.isHidden = true
        self.view.isHidden = true
        
        button1.frame = CGRect(x: 0, y: 90, width: self.view.frame.width , height: 99)
        button1.tag = 1
        button1.setTitle("關於領養", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = .black
        button1.addTarget(self, action: #selector(sideBarBtn(sender:)), for: .touchUpInside)
        button2.frame = CGRect(x: 0 , y: 190, width: self.view.frame.width, height: 99)
        button2.tag = 2
        button2.setTitle("聯絡我", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .black
        button2.addTarget(self, action: #selector(sideBarBtn(sender:)), for: .touchUpInside)
        button3.frame = CGRect(x: 0 , y: 290, width: self.view.frame.width, height: 99)
        button3.tag = 3
        button3.setTitle("關於我", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = .black
        button3.addTarget(self, action: #selector(sideBarBtn(sender:)), for: .touchUpInside)
        
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func show(){
        bgView.isHidden = false
        self.view.isHidden = false
    }
    
    @objc func hide(){
        bgView.isHidden = true
        self.view.isHidden = true
    }
    
    @objc func sideBarBtn(sender:UIButton){
        let currentController = US.getCurrentViewController()
        
        switch sender.tag{
        case 1 :
            let ruleVC = RuleViewController()
            currentController?.present(ruleVC,animated: false,completion: nil)
        case 2 :
            guard MFMailComposeViewController.canSendMail() else{
                print("Mail servies not available")
                return
            }
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["paul20040704@gmail.com"])
            mailController.setSubject("APP領養")
            self.present(mailController,animated:true,completion:nil)
        case 3 :
            let aboutMe = AboutMeViewController()
            currentController?.present(aboutMe,animated: false,completion: nil)
            
        default:
            return
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    



}

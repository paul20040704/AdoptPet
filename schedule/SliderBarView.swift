//
//  SliderBarView.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/3/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class SliderBarView: UIView {
    
    var bgView = UIView()
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
    func setUI(spView:UIView){
        bgView = UIView.init(frame:CGRect(x: spView.frame.width/3 * 2, y: 0, width: spView.frame.width/3, height: spView.frame.height))
        bgView.backgroundColor = .white
        bgView.alpha = 0.7
        self.frame.size.height = screenHeight
        self.frame.size.width = screenWideh/3 * 2
        self.frame.origin = screenOrigin
        self.backgroundColor = .lightGray
        
        spView.addSubview(bgView)
        spView.addSubview(self)
        bgView.isHidden = true
        self.isHidden = true
        
        button1.frame = CGRect(x: 0, y: 90, width: self.frame.width , height: 99)
        button1.tag = 1
        button1.setTitle("關於領養", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = .black
        button1.addTarget(self, action: #selector(sideBarBtn(sender:)), for: .touchUpInside)
        button2.frame = CGRect(x: 0 , y: 190, width: self.frame.width, height: 99)
        button2.tag = 2
        button2.setTitle("test2", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .black
        button3.frame = CGRect(x: 0 , y: 290, width: self.frame.width, height: 99)
        button3.tag = 3
        button3.setTitle("test3", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = .black
        
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(button3)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func show(){
        bgView.isHidden = false
        self.isHidden = false
    }
    
    @objc func hide(){
        bgView.isHidden = true
        self.isHidden = true
    }
    
    @objc func sideBarBtn(sender:UIButton){
        switch sender.tag{
        case 1 :
            let ruleVC = RuleViewController()
            let currentController = self.getCurrentViewController()
            currentController?.present(ruleVC,animated:false,completion:nil)
        case 2 :
            print("2")
        case 3 :
            print("3")
        default:
            return
        }
    }
    
    func getCurrentViewController() -> UIViewController?{
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController{
            var currentController : UIViewController! = rootVC
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }

}

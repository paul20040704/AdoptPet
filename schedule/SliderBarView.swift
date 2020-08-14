//
//  SliderBarView.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/3/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class SliderBarView: UIViewController {
    
    var bgView = UIView()
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
    func setUI(spView:UIView){
        bgView = UIView.init(frame:CGRect(x: spView.frame.width/3 * 2, y: 0, width: spView.frame.width/3, height: spView.frame.height))
        bgView.backgroundColor = .white
        bgView.alpha = 0.7
        self.view.frame.size.height = UIScreen.main.bounds.size.height
        self.view.frame.size.width = UIScreen.main.bounds.size.width/3 * 2
        self.view.frame.origin = UIScreen.main.bounds.origin
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
        button2.setTitle("test2", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .black
        button3.frame = CGRect(x: 0 , y: 290, width: self.view.frame.width, height: 99)
        button3.tag = 3
        button3.setTitle("test3", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = .black
        
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
        switch sender.tag{
        case 1 :
           let VC = RuleViewController()
           self.present(VC, animated: false, completion: nil)
        case 2 :
            print("2")
        case 3 :
            print("3")
        default:
            return
        }
    }
    
  

}

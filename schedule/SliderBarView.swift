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
        self.frame.size.height = UIScreen.main.bounds.size.height
        self.frame.size.width = UIScreen.main.bounds.size.width/3 * 2
        self.frame.origin = UIScreen.main.bounds.origin
        self.backgroundColor = .lightGray
        
        spView.addSubview(bgView)
        spView.addSubview(self)
        bgView.isHidden = true
        self.isHidden = true
        
        button1.frame = CGRect(x: 0, y: 90, width: self.frame.width , height: 99)
        button1.setTitle("test1", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = .black
        button2.frame = CGRect(x: 0 , y: 190, width: self.frame.width, height: 99)
        button2.setTitle("test2", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .black
        button3.frame = CGRect(x: 0 , y: 290, width: self.frame.width, height: 99)
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
    
    
    

}

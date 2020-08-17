//
//  RuleViewController.swift
//  
//
//  Created by 陳彥甫 on 2020/8/13.
//

import UIKit

class RuleViewController: UIViewController {
    
    var backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取消向下滑動返回&&全螢幕
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
            self.modalPresentationStyle = .fullScreen
        }
        
        let ruleTitle = "領養須知"
        let textLabel = UILabel(frame: CGRect(x:0,y:0,width:screenWideh,height: 50))
        textLabel.center = CGPoint(x: screenWideh/2, y: 100)
        textLabel.font = UIFont(name:"Helvetica-Light", size: 50)
        textLabel.textAlignment = .center
        textLabel.text = ruleTitle
        self.view.addSubview(textLabel)
        
        backButton = UIButton(frame: CGRect(x: screenWideh - 50, y: 50 , width: 30, height: 30))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        self.view.backgroundColor = .white
        
    }
    
    
    
    @objc func back(){
        self.dismiss(animated: false, completion: nil)
    }

    
    
    
    
    
    
}

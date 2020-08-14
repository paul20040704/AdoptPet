//
//  RuleViewController.swift
//  
//
//  Created by 陳彥甫 on 2020/8/13.
//

import UIKit

class RuleViewController: UIViewController {
    
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let ruleText = "111111111111"
        let textLabel = UILabel(frame: CGRect(x:0,y:0,width: 200,height: 50))
        textLabel.center = CGPoint(x: 300, y: 200)
        textLabel.text = ruleText
        self.view.addSubview(textLabel)
        //self.view.backgroundColor = .gray
        
    }
    


    
    
    
    
    
    
}

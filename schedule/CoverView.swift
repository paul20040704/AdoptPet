//
//  CoverView.swift
//  schedule
//
//  Created by paul on 2021/8/10.
//  Copyright © 2021 TimeCity. All rights reserved.
//

import UIKit
import SnapKit

class CoverView: UIView {

    static let coverView = CoverView()
    let label = UILabel()
    
    func setCoverView(VC:UIViewController) {
        self.frame = CGRect(x: 0, y: (VC.navigationController?.navigationBar.frame.size.height)! + 20, width: screenWidth, height: screenWidth + 40)
        self.backgroundColor = .black
        self.alpha = 0.95
        
        label.text = "已屏蔽"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        self.addSubview(label)
        VC.view.addSubview(self)
            
        label.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(150)
            make.centerX.equalTo(self.center.x)
            make.top.equalTo(VC.view).offset(200)
        }
    }
    
    func hide() {
        self.removeFromSuperview()
    }

}
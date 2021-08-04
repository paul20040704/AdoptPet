//
//  homeMenuView.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/12/22.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import SnapKit

protocol DeleteDelegate {
    func delete(id:String)
    func edit(id:String)
}
class HomeMenuView: UIView {

    static let homeMenuView = HomeMenuView()
    var delegate : DeleteDelegate?
    var id = String()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func showMenuView(id:String) {
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        self.id = id
        self.setButtonView()
        self.setTap()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    @objc func hideMenuView() {
        self.removeFromSuperview()
    }
    //設定選單
    func setButtonView() {
        let buttonView = UIView()
        let lineLab1 = UILabel()
        let lineLab2 = UILabel()
        let lineLab3 = UILabel()
        
        let button1 = UIButton()
        button1.tag = 1
        let button2 = UIButton()
        button2.tag = 2
        let button3 = UIButton()
        button3.tag = 3
        
        buttonView.backgroundColor = .darkGray
        buttonView.layer.cornerRadius = 5.0
        self.addSubview(buttonView)
        buttonView.snp.makeConstraints { (make) in
            //make.width.equalTo(self.frame.width)
            make.height.equalTo(400)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-20)
        }
        button1.setTitle("刪除", for: .normal)
        button1.setTitleColor(.red, for: .normal)
        button1.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        button2.setTitle("編輯", for: .normal)
        button2.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        button3.setTitle("取消", for: .normal)
        button3.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        buttonView.addSubview(button1)
        buttonView.addSubview(button2)
        buttonView.addSubview(button3)
        button1.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.top.equalTo(buttonView)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        button2.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.top.equalTo(buttonView).offset(82)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        button3.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.bottom.equalTo(buttonView)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        
        buttonView.addSubview(lineLab1)
        buttonView.addSubview(lineLab2)
        buttonView.addSubview(lineLab3)
        lineLab1.backgroundColor = .white
        lineLab2.backgroundColor = .white
        lineLab3.backgroundColor = .white
        
        lineLab1.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(buttonView).offset(80)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        lineLab2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(buttonView).offset(161)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        lineLab3.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(buttonView).offset(-81)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        
        
    }
    //設定手勢
    func setTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenuView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func btnClick(sender:UIButton) {
        switch sender.tag {
        case 1:
            let alert = UIAlertController.init(title: "警告", message: "請問是否要刪除?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "確定", style: .default) { (action) in
                self.delegate?.delete(id:self.id)
                self.hideMenuView()
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        case 2:
            print("2")
            self.delegate?.edit(id:self.id)
            self.hideMenuView()
        default:
            self.hideMenuView()
        }
    }
    
    
}

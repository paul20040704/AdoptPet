//
//  reportView.swift
//  schedule
//
//  Created by paul on 2021/8/10.
//  Copyright © 2021 TimeCity. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class ReportView: UIView {
    
    static let reportView = ReportView()
    var postID = String()
    var superVC = UIViewController()
    var isReport = false
    
    
    func showOptionView(id:String,VC:UIViewController) {
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        //UIApplication.shared.keyWindow?.addSubview(self)
        VC.view.addSubview(self)
        self.postID = id
        self.superVC = VC
        judgeIsReport()
        setButtonView()
        setTap()
    }
    
    @objc func hideMenuView() {
        self.removeFromSuperview()
    }
    
    func setButtonView() {
        var messgae = ""
        switch isReport {
        case true:
            messgae = "取消屏蔽圖片內容"
        default:
            messgae = "屏蔽此圖片內容"
        }
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
            make.height.equalTo(300)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).offset(-50)
            make.bottom.equalTo(self).offset(-50)
        }
        
        button1.setTitle("檢舉", for: .normal)
        button1.setTitleColor(.red, for: .normal)
        button1.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        button2.setTitle(messgae, for: .normal)
        button2.setTitleColor(.red, for: .normal)
        button2.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        button3.setTitle("取消", for: .normal)
        button3.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        buttonView.addSubview(button1)
        buttonView.addSubview(button2)
        buttonView.addSubview(button3)
        button1.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.top.equalTo(buttonView)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        button2.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.top.equalTo(buttonView).offset(62)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        button3.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.bottom.equalTo(buttonView)
            make.left.equalTo(buttonView)
            make.right.equalTo(buttonView)
        }
        
        buttonView.addSubview(lineLab1)
        buttonView.addSubview(lineLab2)
        buttonView.addSubview(lineLab3)
        lineLab1.backgroundColor = .black
        lineLab2.backgroundColor = .black
        lineLab3.backgroundColor = .black
        
        lineLab1.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(buttonView).offset(60)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        lineLab2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(buttonView).offset(121)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        lineLab3.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(buttonView).offset(-61)
            make.left.equalTo(buttonView).offset(10)
            make.right.equalTo(buttonView).offset(-10)
        }
        
        
    }
    
    func setTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenuView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func btnClick(sender:UIButton) {
        switch sender.tag {
        case 1:
            let alertVC = UIAlertController.init(title: "檢舉", message: "請問是否要檢舉此內容？", preferredStyle: .actionSheet)
            let ok = UIAlertAction.init(title: "是", style: .destructive) { (action) in
                let databaseRef = Database.database().reference().child("Repoet").child(self.postID)
                if let uid = Auth.auth().currentUser?.uid{
                    databaseRef.setValue(uid)
                }else{
                    databaseRef.setValue("guest")
                }
                let alert = US.alertVC(message: "已檢舉", title: "提醒")
                self.superVC.present(alert, animated: true, completion: nil)
                self.hideMenuView()
            }
            let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
            alertVC.addAction(ok)
            alertVC.addAction(cancel)
            superVC.present(alertVC, animated: true, completion: nil)
        case 2:
            var tempArr = Array<String>()
            switch isReport {
            case true:
                if let reportArr = UD.array(forKey: "report") as? Array<String>{
                    tempArr = reportArr
                    var i = 0
                    for report in reportArr {
                        if report == postID {
                            tempArr.remove(at: i)
                            UD.setValue(tempArr, forKey: "report")
                            UD.synchronize()
                            isReport = false
                            let alert = US.alertVC(message: "已取消屏蔽", title: "提醒")
                            self.superVC.present(alert, animated: true, completion: nil)
                            CoverView.coverView.hide()
                            self.hideMenuView()
                        }
                        i += 1
                    }
                }
            default:
                if let reportArr = UD.array(forKey: "report") as? Array<String> {
                    tempArr = reportArr
                    tempArr.append(postID)
                    UD.setValue(tempArr, forKey: "report")
                }else{
                    tempArr.append(postID)
                    UD.setValue(tempArr, forKey: "report")
                }
                UD.synchronize()
                isReport = false
                let alert = US.alertVC(message: "已屏蔽內容", title: "提醒")
                self.superVC.present(alert, animated: true, completion: nil)
                CoverView.coverView.setCoverView(VC: self.superVC)
                self.hideMenuView()
            }
        default:
            self.hideMenuView()
        }
    }
    
    func judgeIsReport() {
        if let reportArr = UD.array(forKey: "report") {
            isReport = reportArr.contains { (id) -> Bool in
                id as! String == postID
            }
        }else{
            isReport = false
        }
    }
    
}

//
//  HomeVC.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/11/2.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseStorage

class HomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userLab: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        getUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: "login"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let id = Auth.auth().currentUser?.uid {
            isLogin = true
        }else{
            isLogin = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    
    func getUserInfo() {
        if !(isLogin) {
            self.userLab.text = "尚未登入"
            self.loginBtn.setTitle("點此登入", for: .normal)
        }
        if let name = Auth.auth().currentUser?.displayName {
            self.userLab.text = name
            self.loginBtn.setTitle("登出", for: .normal)
            return
        }
        if let id = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("User").child(id)
            databaseRef.observe(.value) { (user) in
                if let userData = user.value as? [String:String] {
                    self.userLab.text = userData["name"]
                    self.loginBtn.setTitle("登出", for: .normal)
                }
            }
        }
    }
    
    @objc func login() {
        isLogin = true
        getUserInfo()
    }
    
   
    @IBAction func homeBtn(_ sender: Any) {
        if isLogin {
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    isLogin = false
                    getUserInfo()
                    let alert = US.alertVC(message: "登出成功", title: "提醒")
                    self.present(alert, animated: true, completion: nil)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
        }else {
            let sb = UIStoryboard(name: "Member", bundle: nil)
            let memberVC = sb.instantiateViewController(withIdentifier: "MemberVC") as! MemberVC
            self.present(memberVC, animated: true, completion: nil)
        }
    }
    
}

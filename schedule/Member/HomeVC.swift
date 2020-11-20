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
import SDWebImage

class HomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var userLab: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    var isLogin = false
    var firstTime = true
    var userLikeArr = Array<Dictionary<String,Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        getUserInfo()
        getUserLike()
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: "login"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstTime {
            setUserImage()
            firstTime = false
        }
        if (Auth.auth().currentUser?.uid) != nil {
            isLogin = true
        }else{
            isLogin = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userLikeArr.count
        }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTVCell
        let likeDic = userLikeArr[indexPath.row]
        cell.nameLab.text = likeDic["userID"] as! String
        cell.kindLab.text = "種類 : \(likeDic["kind"] as! String)"
        cell.dateLab.text = "拾獲日 : \(likeDic["pickDate"] as! String)"
        if let userUrl = URL(string:likeDic["userUrlStr"] as! String) {
            let userCache = SDImageCache.shared.imageFromCache(forKey: "\(userUrl)")
            cell.userImage.image = userCache
        }
        guard let urlArr = likeDic["photoArray"] as? Array<String> else{return cell}
        if let postUrl = URL(string: urlArr[0]) {
            let postCache = SDImageCache.shared.imageFromCache(forKey: "\(postUrl)")
            cell.likeImage.image = postCache
        }
        return cell
        
    }
    
    //判斷是否登入並取得用戶資訊
    func getUserInfo() {
        if !(isLogin) {
            self.userLab.text = "尚未登入"
            self.loginBtn.setTitle("點此登入", for: .normal)
        }
        if let name = Auth.auth().currentUser?.displayName {
            userDisplayName = name
            self.userLab.text = name
            self.loginBtn.setTitle("登出", for: .normal)
            return
        }
        if let id = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("User").child(id)
            databaseRef.observe(.value) { (user) in
                if let userData = user.value as? [String:String] {
                    userDisplayName = userData["name"]!
                    self.userLab.text = userData["name"]
                    self.loginBtn.setTitle("登出", for: .normal)
                }
            }
        }
    }
    
    @objc func login() {
        isLogin = true
        getUserInfo()
        setUserImage()
        getUserLike()
    }
    
   
    @IBAction func homeBtn(_ sender: Any) {
        if isLogin {
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    userImage.image = UIImage(named: "user")
                    isLogin = false
                    getUserInfo()
                    userLikeArr.removeAll()
                    homeTableView.reloadData()
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
    
    //設定用戶照片
    func setUserImage(){
        if let url = Auth.auth().currentUser?.photoURL {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data , let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.userImage.image = image
                    }
                }
            }
            task.resume()
        }
    }
    
    //取得用戶收藏的資訊
    func getUserLike(){
        let group : DispatchGroup = DispatchGroup()
        if let id = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference().child("UserLike").child(id)
            databaseRef.observe(.value) { (data) in
                self.userLikeArr.removeAll()
                if let likeData = data.value as? [String:Any]{
                    let keyArr = Array(likeData.keys)
                    for key in keyArr {
                        group.enter()
                        let databaseRef = Database.database().reference().child("LostPostUpload").child(key)
                        databaseRef.observe(.value) { (data) in
                            if let postData = data.value as? [String:Any]{
                                self.userLikeArr.append(postData)
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: DispatchQueue.main) {
                        print("reloadData")
                        self.homeTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
}

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
import PKHUD
import SnapKit


class HomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var userLab: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var segmentedIndex : Int = 0
    var attentionKey = Array<String>()
    var postDic = Dictionary<String,Any>()
    var myOwnKey = Array<String>()
    
    var isLogin = false
    var firstTime = true
    var coverView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.flash(.systemActivity, onView: self.view, delay: 2, completion: nil)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        getUserInfo()
        getUserLike()
        
        setCoverView()
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: "login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        segmentedControl.addTarget(self, action: #selector(segmentedChange(sender:)), for: .valueChanged)
        
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
    
    @objc func segmentedChange(sender : UISegmentedControl){
        
        segmentedIndex = sender.selectedSegmentIndex
        self.homeTableView.reloadData()
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var keyArr = [""]
        switch segmentedIndex {
        case 0:
            keyArr = attentionKey
        default:
            keyArr = myOwnKey
        }
        if keyArr.count == 0{
            return 1
        }else{
            return keyArr.count
        }
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var keyArr = [""]
        switch segmentedIndex {
        case 0:
            keyArr = attentionKey
        default:
            keyArr = myOwnKey
        }
    if keyArr.count > 0{
        coverView.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTVCell
        let key = keyArr[indexPath.row]
        let likeDic = postDic[key] as! [String:Any]
        cell.nameLab.text = likeDic["userID"] as! String
        cell.kindLab.text = "種類 : \(likeDic["kind"] as! String)"
        cell.dateLab.text = "拾獲日 : \(likeDic["pickDate"] as! String)"
        if let userUrl = URL(string:likeDic["userUrlStr"] as! String) {
            let userCache = SDImageCache.shared.imageFromCache(forKey: "\(userUrl)")
            if userCache != nil{
                cell.userImage.image = userCache
            }else{
                cell.userImage.image = UIImage(named: "user")
                downLoadImage(imageUrl: userUrl, indexPath: indexPath)
            }
        }
        guard let urlArr = likeDic["photoArray"] as? Array<String> else{return cell}
        if let postUrl = URL(string: urlArr[0]) {
            let postCache = SDImageCache.shared.imageFromCache(forKey: "\(postUrl)")
            if postCache != nil{
                cell.likeImage.image = postCache
            }else{
                cell.likeImage.image = UIImage.gif(name: "loadView")
                downLoadImage(imageUrl: postUrl, indexPath: indexPath)
            }
        }
        return cell
    }else{
        let cell = UITableViewCell()
        coverView.isHidden = false
        return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var keyArr = [""]
        switch segmentedIndex {
        case 0:
            keyArr = attentionKey
        default:
            keyArr = myOwnKey
        }
        guard let id = keyArr[indexPath.row] as? String else {return}
        guard let info = postDic[id] as? [String : Any] else {return}
        let sb = UIStoryboard.init(name: "Third", bundle: Bundle.main)
        let lostDetailVC = sb.instantiateViewController(withIdentifier: "LostDetailVC") as! LostDetailViewController
        lostDetailVC.hidesBottomBarWhenPushed = true
        lostDetailVC.info = info
        lostDetailVC.key = id
        navigationController?.show(lostDetailVC, sender: nil)
        
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
        HUD.flash(.systemActivity, onView: self.view, delay: 2, completion: nil)
        isLogin = true
        getUserInfo()
        setUserImage()
        getUserLike()
    }
    
    @objc func reload() {
        homeTableView.reloadData()
    }
   
    @IBAction func homeBtn(_ sender: Any) {
        if isLogin {
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    userImage.image = UIImage(named: "user")
                    isLogin = false
                    getUserInfo()
                    attentionKey.removeAll()
                    myOwnKey.removeAll()
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
            let cachedImage = SDImageCache.shared.imageFromCache(forKey: "\(url)")
            if cachedImage == nil {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data , let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            self.userImage.image = image
                            SDImageCache.shared.store(image, forKey: "\(url)", completion: nil)
                        }
                    }
                }
            task.resume()
            }else{
                self.userImage.image = cachedImage
            }
        }
    }
    
    //取得用戶收藏的資訊
    func getUserLike(){
        let group = DispatchGroup()
        if let id = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference().child("UserLike")
            databaseRef.observe(.value) { (data) in
                group.enter()
                self.attentionKey.removeAll()
                if let likeData = data.value as? [String:Any]{
                    if let keyDic = likeData[id] as? [String:Any]{
                        let keyArr = Array(keyDic.keys)
                        self.attentionKey = keyArr
                        }
                    group.leave()
                    }
                }
            
            group.enter()
            let postDatabaseRef = Database.database().reference().child("LostPostUpload")
            postDatabaseRef.observe(.value) { (data) in
                group.enter()
                self.postDic.removeAll()
                if let postData = data.value as? [String:Any]{
                    self.postDic = postData
                    group.leave()
                    }
                }
            
            group.enter()
            let ownDatabaseRef = Database.database().reference().child("UserOwn")
            ownDatabaseRef.observe(.value) { (data) in
                group.enter()
                self.myOwnKey.removeAll()
                if let ownData = data.value as? [String:Any]{
                    if let keyDic = ownData[id] as? [String:Any]{
                        let keyArr = Array(keyDic.keys)
                        self.myOwnKey = keyArr
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                self.homeTableView.reloadData()
            }
        }
    }
    
    
    //下載cell要呈現的Image
    func downLoadImage(imageUrl: URL, indexPath : IndexPath) -> (){
           SDWebImageDownloader.shared.downloadImage(with: imageUrl, options: .useNSURLCache, progress: { (receivedSize, expectedSize, url) in
           }) { (image, data, error, finished) in
               if error == nil{
                   SDImageCache.shared.store(image, forKey: "\(imageUrl)",toDisk: true ,completion: nil)
                   DispatchQueue.main.async {
                       self.performSelector(onMainThread: #selector(self.reloadImageCell(indexPath:)), with: indexPath, waitUntilDone: false)
                   }
               }else{
                   return
               }
           }
    }
    
    @objc func reloadImageCell(indexPath: IndexPath) -> () {

        homeTableView.reloadRows(at: [indexPath], with: .top)
    }
    
    func setCoverView() {
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: homeTableView.frame.width, height: homeTableView.frame.height))
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //let coverLab = UILabel(frame: CGRect(x: coverView.frame.width/2 - 75, y: 50, width: 200 ,height: 50))
        let coverLab = UILabel()
        coverLab.text = "目前沒有資訊"
        coverLab.font = UIFont(name: "System Medium", size: 25)
        coverLab.font = coverLab.font.withSize(25)
        coverLab.textColor = .white
        coverLab.textAlignment = .center
        coverView.addSubview(coverLab)
        homeTableView.addSubview(coverView)
        
        coverLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(coverView)
            make.top.equalTo(coverView).offset(50)
        }
        
    }
    
}

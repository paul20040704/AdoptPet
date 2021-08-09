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


class HomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,DeleteDelegate{

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
        HUD.flash(.systemActivity, onView: self.view, delay: 2.5, completion: nil)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        HomeMenuView.homeMenuView.delegate = self
        getUserInfo()
        getUserLike()
        
        setCoverView()
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: "login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getUserLike), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTVCell
        var keyArr = [""]
        switch segmentedIndex {
        case 0:
            keyArr = attentionKey
            cell.menuBtn.isHidden = true
        default:
            keyArr = myOwnKey
            cell.menuBtn.isHidden = false
        }
    if keyArr.count > 0{
        coverView.isHidden = true
        let key = keyArr[indexPath.row]
        let likeDic = postDic[key] as! [String:Any]
        cell.id = key
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
        let noCell = UITableViewCell()
        coverView.isHidden = false
        return noCell
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
            self.navigationItem.title = "未登入"
            self.loginBtn.setTitle("點此登入", for: .normal)
        }else{
            self.navigationItem.title = "已登入"
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
    
    //取得用戶收藏&擁有的資訊
    @objc func getUserLike(){
        HUD.show(.systemActivity)
        let group = DispatchGroup()
        if let id = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference().child("UserLike")
            group.enter()
            databaseRef.observeSingleEvent(of: .value) { (data) in
                self.attentionKey.removeAll()
                if let likeData = data.value as? [String:Any]{
                    if let keyDic = likeData[id] as? [String:Any]{
                        let keyArr = Array(keyDic.keys)
                        self.attentionKey = keyArr
                        }
                    group.leave()
                    }
                }
            
            let postDatabaseRef = Database.database().reference().child("LostPostUpload")
            group.enter()
            postDatabaseRef.observeSingleEvent(of: .value) { (data) in
                self.postDic.removeAll()
                if let postData = data.value as? [String:Any]{
                    self.postDic = postData
                    group.leave()
                    }
                }
            
            let ownDatabaseRef = Database.database().reference().child("UserOwn")
            group.enter()
            ownDatabaseRef.observeSingleEvent(of: .value) { (data) in
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
                //判斷用戶收藏的文章是否被刪除，如果找不到文章刪除使用者的收藏。
                var i = 0
                for key in self.attentionKey {
                    let dicKeys = self.postDic.keys
                    if !(dicKeys.contains(key)){
                        self.attentionKey.remove(at: i)
                        let databaseRef = Database.database().reference().child("UserLike").child(id).child(key)
                        databaseRef.removeValue()
                    }
                    i += 1
                }
                self.homeTableView.reloadData()
                HUD.hide()
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
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: homeTableView.frame.width, height: screenHeight))
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //let coverLab = UILabel(frame: CGRect(x: coverView.frame.width/2 - 75, y: 50, width: 200 ,height: 50))
        let coverLab = UILabel()
        coverLab.text = "目前沒有資訊"
        coverLab.font = UIFont(name: "System Medium", size: 30)
        coverLab.font = coverLab.font.withSize(25)
        coverLab.textColor = .white
        coverLab.textAlignment = .center
        coverView.addSubview(coverLab)
        homeTableView.addSubview(coverView)
        
        coverLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(coverView.center.x)
            make.top.equalTo(coverView).offset(50)
        }
        
    }
    
    //DeleteDelegate
    func delete(id:String) {
        HUD.show(.systemActivity)
        let group = DispatchGroup()
        print("刪除 : \(id)")
        if let userID = Auth.auth().currentUser?.uid {
            group.enter()
            let databaseRef = Database.database().reference().child("LostPostUpload").child(id)
            databaseRef.removeValue { (error, response) in
                group.leave()
                if error != nil {
                    print("error : \(error?.localizedDescription)")
                }
            }
            let databaseRef1 = Database.database().reference().child("UserOwn").child(userID).child(id)
            group.enter()
            databaseRef1.removeValue { (error, response) in
                group.leave()
                if error != nil{
                    print("error : \(error?.localizedDescription)")
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                self.getUserLike()
                HUD.hide()
            }
            
        }else{
            HUD.hide()
        }
    }
    
    func edit(id: String) {
        let sb = UIStoryboard.init(name: "Third", bundle: nil)
        let postVC = sb.instantiateViewController(withIdentifier: "postVC") as! LostPostViewController
        postVC.mode = 1
        postVC.selectID = id
        self.present(postVC, animated: true, completion: nil)
        
        
    }
    
    
}

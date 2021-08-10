//
//  LostDetailViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
import Reachability
import Firebase

class LostDetailViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var likeLab: UILabel!
    
    
    var reachability = try! Reachability()
    var info = [String:Any]()
    var key = String()
    var urlCount = 0
    var urlArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "遺失待領回"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        layout.sectionInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 414, height: 414)
        
        collectionView.isPagingEnabled = true
        
        self.reachability!.whenReachable = { reachability in
            self.netLabel.isHidden = true
        }
        
        self.reachability?.whenUnreachable = { reachability in
            self.netLabel.isHidden = false
        }
        
        do {
            try self.reachability!.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
        
        if let array = info["photoArray"] as? Array<String>{
            urlArray = array
            urlCount = urlArray.count
        }
        // Do any additional setup after loading the view.
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = urlCount
        pageControl.currentPage = 0
        
        userLabel.text = info["userID"] as! String
        kindLabel.text = "種類 : \(info["kind"] as! String)"
        dateLabel.text = "拾獲日期 : \(info["pickDate"] as! String)"
        placeLabel.text = "拾獲地 : \(info["place"] as! String)"
        contactLabel.text = "聯絡方式 : \(info["contact"] as! String)"
        remarkLabel.text = "特徵 : \(info["remark"] as! String)"
        let urlStr = info["userUrlStr"] as! String
        if let url = URL(string: urlStr){
            let cachedImage = SDImageCache.shared.imageFromDiskCache(forKey: "\(url)")
            userImage.image = cachedImage
        }else{
            userImage.image = UIImage(named: "user")
        }
        
        setNVItem()
        setCoverView()
        
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return urlCount
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LostDetailCVCell
        if let url = URL(string: urlArray[indexPath.row]){
            let cachedImage = SDImageCache.shared.imageFromCache(forKey: "\(url)")
            if cachedImage == nil {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data , let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            SDImageCache.shared.store(image, forKey: "\(url)", completion: nil)
                            cell.lostImageView.image = image
                        }
                    }
                }
                task.resume()
            }else{
                cell.lostImageView.image = cachedImage
            }
        }else{
            cell.lostImageView.image = UIImage(named: "user")
        }
            
            return cell
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    func setNVItem() {
            if let id = Auth.auth().currentUser?.uid {
                let databaseRef = Database.database().reference().child("UserLike").child(id)
                databaseRef.observe(.value) { (data) in
                    if let likeData = data.value as? [String:Any]{
                        let keyArr = Array(likeData.keys)
                        if keyArr.contains(self.key){
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消收藏", style: .plain, target: self, action: #selector(self.cancelFollow))
                                self.likeLab.text = "已收藏"
                        }else{
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "加入收藏", style: .plain, target: self, action: #selector(self.addFollow))
                            self.likeLab.text = "未收藏"
                        }
                    }
                    HUD.hide()
                }
            }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "加入收藏", style: .plain, target: self, action: #selector(addFollow))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }
    
    @objc func addFollow() {
        HUD.show(.systemActivity)
        if let id = Auth.auth().currentUser?.uid {
            let postArr = [""]
            let databaseRef = Database.database().reference().child("UserLike").child(id).child(key)
                databaseRef.setValue(postArr) { (error, dataRef) in
                    if error != nil{
                        let alert = US.alertVC(message: "加入收藏失敗", title: "提醒")
                        self.present(alert, animated: true, completion: nil)
                        HUD.hide()
                    }else{
                        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                        let alert = US.alertVC(message: "加入收藏成功", title: "提醒")
                        self.present(alert, animated: true, completion: nil)
                        self.setNVItem()
                        HUD.hide()
                        }
                    }
        }else {
            let alert = US.alertVC(message: "請先登入", title: "提醒")
            self.present(alert, animated: true, completion: nil)
            HUD.hide()
        }
        
    }
    
    @objc func cancelFollow(){
        HUD.show(.systemActivity)
        if let id = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("UserLike").child(id).child(key)
            databaseRef.removeValue { (error, dataRef) in
                if error != nil{
                    let alert = US.alertVC(message: "取消收藏失敗", title: "提醒")
                    self.present(alert, animated: true, completion: nil)
                    HUD.hide()
                }else{
                    NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                    let alert = US.alertVC(message: "取消收藏成功", title: "提醒")
                    self.present(alert, animated: true, completion: nil)
                    self.setNVItem()
                    HUD.hide()
                }
            }
        }
    }
    
    @IBAction func report(_ sender: Any) {
        ReportView.reportView.showOptionView(id: key,VC: self)
    }
    
    func setCoverView(){
        if let reportArr = UD.array(forKey: "report"){
            let isReport = reportArr.contains { (reportID) -> Bool in
                reportID as! String == key
            }
            if isReport {
                CoverView.coverView.setCoverView(VC: self)
            }
        }
    }
    
    

}

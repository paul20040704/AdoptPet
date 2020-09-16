//
//  LostFollowViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/15.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class LostFollowViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var followInfo = [[String:Any]]()
    var keyArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followInfo.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFollowInfo()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LostFollowTableViewCell
        let info = followInfo[indexPath.row]
        cell.kindLabel.text = "種類 : \(info["kind"] as! String)"
        cell.placeLabel.text = "拾獲地 : \(info["place"] as! String)"
        cell.dateLabel.text = "拾獲日期 : \(info["pickDate"] as! String)"
        let urlArr = info["photoArray"] as! [String]
        setImageCell(cell: cell, indexPath: indexPath, url: URL(string: urlArr[0])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if followInfo.count > 0 {
            let info = followInfo[indexPath.row]
            let sb = UIStoryboard.init(name: "Third", bundle: Bundle.main)
            let lostDetailVC = sb.instantiateViewController(withIdentifier: "LostDetailVC") as! LostDetailViewController
            lostDetailVC.hidesBottomBarWhenPushed = true
            lostDetailVC.info = info
            lostDetailVC.key = keyArr[indexPath.row]
            lostDetailVC.type = 1
            navigationController?.show(lostDetailVC, sender: nil)
        }
    }

  
    func updateFollowInfo(){
        followInfo = [[String:Any]]()
        let databaseRef = Database.database().reference().child("LostPostUpload")
        databaseRef.observe(.value) { (postData) in
            if let firebaseData = postData.value as? [String:Any] {
                let keys = Array(firebaseData.keys)
                if let followArray = UD.array(forKey: "LostKey") as? [String] {
                    for lostKey in followArray  {
                        if keys.contains(lostKey){
                            self.followInfo.append(firebaseData[lostKey] as! [String : Any])
                            self.keyArr.append(lostKey)
                        }
                    }
                }
                self.tableView.reloadData()
                self.navigationItem.title = "我的關注 : \(self.followInfo.count) 筆"
            }
        }
    }
    
    func setImageCell(cell: LostFollowTableViewCell, indexPath: IndexPath, url: URL) -> () {
        let cachedImage = SDImageCache.shared.imageFromDiskCache(forKey: "\(url)")
        if cachedImage == nil{
            downLoadImage(imageUrl: url, indexPath: indexPath)
            cell.photoImage?.image = UIImage.gif(name: "loadView")
        }else{
            cell.photoImage?.image = cachedImage
        }
    }
    
    func downLoadImage(imageUrl: URL,indexPath : IndexPath) -> (){
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
        tableView.rectForRow(at: indexPath)
    }
    
    
    
    
    
    
    
}

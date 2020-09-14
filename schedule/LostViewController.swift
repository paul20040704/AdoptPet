//
//  AdoptViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/4.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseStorage
import SDWebImage

class LostViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    var infoDic = [String:Any]()
    var infoKey = Array<String>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        updateLostView()

    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoKey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LostCollectionViewCell
        guard let info = infoDic[infoKey[indexPath.row]] as? [String:Any] else{return cell}
        cell.kindLael.text = "種類 : \(info["kind"] as! String)"
        cell.placeLabel.text = "發現地 : \(info["place"] as! String)"
        cell.dateLabel.text = "發現日 : \(info["pickDate"] as! String)"
        guard let urlArray = info["photoArray"] as? Array<String> else{return cell}
        let urlString = urlArray[0]
        setImageCell(cell: cell, indexPath: indexPath, url: URL(string: urlString)!)
        //cell.imageView.image = UIImage.gif(name: "loadView")
        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let info = infoDic[infoKey[indexPath.row]] as? [String:Any] else{return}
        let sb = UIStoryboard.init(name: "Third", bundle: Bundle.main)
        let lostDetailVC = sb.instantiateViewController(withIdentifier: "LostDetailVC") as! LostDetailViewController
        lostDetailVC.hidesBottomBarWhenPushed = true
        lostDetailVC.info = info
        navigationController?.show(lostDetailVC, sender: nil)
        
    }



    
    func updateLostView() {
        let databaseRef = Database.database().reference().child("LostPostUpload")
        databaseRef.observe(.value) { (postData) in
            if let firebaseData = postData.value as? [String:Any] {
                self.infoDic = firebaseData
                self.infoKey = Array(firebaseData.keys)
                self.collectionView.reloadData()
            }
        }
    }
    
    func setImageCell(cell: LostCollectionViewCell, indexPath: IndexPath, url: URL) -> () {
        let cachedImage = SDImageCache.shared.imageFromDiskCache(forKey: "\(url)")
        if cachedImage == nil{
            downLoadImage(imageUrl: url, indexPath: indexPath)
            cell.imageView?.image = UIImage.gif(name: "loadView")
        }else{
            cell.imageView?.image = cachedImage
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
        collectionView.reloadItems(at: [indexPath])
    }
    
    
 
}

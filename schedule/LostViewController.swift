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
        if let imageUrl = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data , let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
            task.resume()
        }
        return cell
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
 
}

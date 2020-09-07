//
//  AdoptViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/4.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import RealmSwift

class LostViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCount = 20
    var lostInfoArr = [RLM_LostApi]()
    var pageStatus: PageStatus = .NotLoadingMore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        resetInfoArr()
    }
    
    func resetInfoArr() {
        lostInfoArr = []
        let realm = try! Realm()
        let orders = realm.objects(RLM_LostApi.self)
        if orders.count > 10{
            for order in orders{
                lostInfoArr.append(order)
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if lostInfoArr.count < 1{
            return 1
        }
        switch self.pageStatus {
        case .LoadingMore:
            if lostInfoArr.count > arrayCount {
                return arrayCount + 1
            }else{
                return lostInfoArr.count + 1
            }
        default:
            if lostInfoArr.count > arrayCount {
                return arrayCount
            }else{
            return lostInfoArr.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LostCollectionViewCell
        let info = lostInfoArr[indexPath.row]
        let cellImage = US.loadImage(fileName: "\(info.chip_id).jpg")
        cell.imageView.image = cellImage?.scaleImage(scaleSize: 0.5)
        cell.kindLabel.text = info.pet_kind
        cell.sexLabel.text = info.pet_sex
        cell.typeLabel.text = info.pet_type
        cell.dateLabel.text = info.lost_date
        return cell
    }

}



extension LostViewController : UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > self.collectionView.frame.height , self.pageStatus == .NotLoadingMore else{return}
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10{
            self.pageStatus = .LoadingMore
            self.collectionView.reloadData() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.collectionView.reloadData()
                    self.pageStatus = .NotLoadingMore
                    self.arrayCount += 20
                    //預載20張圖片
                    print("******\(self.arrayCount)")
                    for i in self.arrayCount...self.arrayCount + 20{
                        if self.lostInfoArr.count > i {
                        US.downloadImage(path: self.lostInfoArr[i-1].album_file, name: self.lostInfoArr[i-1].chip_id)
                        }
                    }
                }
            }
        }
    }
}


extension UICollectionView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 1, animations: { self.reloadData() })
            { _ in completion() }
    }
}

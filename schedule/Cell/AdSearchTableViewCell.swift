//
//  AdSearchTableViewCell.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/8/25.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class AdSearchTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionArray : Array<String> = [""]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame.size.height = 300
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        // section與section之間的距離(如果只有一個section，可以想像成frame)
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
//        // cell的寬、高
//        layout.itemSize = CGSize(width: 100, height: 30)
//        // 滑動方向預設為垂直。注意若設為垂直，則cell的加入方式為由左至右，滿了才會換行；若是水平則由上往下，滿了才會換列
//        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
//        
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AdSearchCollectionViewCell
        cell.labelBtn.setTitle(collectionArray[indexPath.row], for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .black
        print(collectionArray[indexPath.row])
    }


}

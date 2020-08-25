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
    
    var info = ["公","母"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(info.count)
        return info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AdSearchCollectionViewCell
        cell.labelBtn.titleLabel?.text = info[indexPath.row]
        return cell
        
    }

}

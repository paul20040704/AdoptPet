//
//  AdSearchTableViewCell.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/8/25.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

var sexArray = Array<String>()
var typeArray = Array<String>()
var sizeArray = Array<String>()
var localArray = Array<String>()
var ageArray = Array<String>()
var sterilizationArray = Array<String>()

class AdSearchTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionArray : Array<String> = [""]
    var tableTag : Int = 0
    var localIsSelect : Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(resetCollection), name: NSNotification.Name(rawValue: "reset"), object: nil)
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame.size.height = 300

        
        
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
        cell.chooseLabel.text = collectionArray[indexPath.row]
        cell.tag = tableTag
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AdSearchCollectionViewCell
        if cell.tag > 0 {
            cell.chooseLabel.backgroundColor = .lightGray
            addCondition(tag: cell.tag, condition: collectionArray[indexPath.row])
            cell.tag = -(cell.tag)
        }else if cell.tag < 0 {
            cell.chooseLabel.backgroundColor = .systemYellow
            cell.tag = -(cell.tag)
            removeCondition(tag: cell.tag, condition: collectionArray[indexPath.row])
        }
    }
    
    @objc func resetCollection(){
        print("resetCollection")
        for i in 0...collectionArray.count - 1  {
            let index = IndexPath.init(row: i, section: 0)
            let cell = collectionView.cellForItem(at: index) as! AdSearchCollectionViewCell
            if cell.tag < 0 {
            cell.tag = -(cell.tag)
            cell.chooseLabel.backgroundColor = .systemYellow
            }
            sexArray.removeAll()
            typeArray.removeAll()
            sizeArray.removeAll()
            localArray.removeAll()
            ageArray.removeAll()
            sterilizationArray.removeAll()
           
        }
    }
    
    func addCondition(tag:Int,condition:String){
        switch tag {
        case 1:
            if condition == "公"{
                sexArray.append("M")
            }
            else if condition == "母"{
                sexArray.append("F")
            }
        case 2:
            typeArray.append(condition)
        case 3:
            if condition == "大型"{
               sizeArray.append("BIG")
            }
            else if condition == "中型"{
               sizeArray.append("MEDIUM")
            }
            else if condition == "小型"{
               sizeArray.append("SMALL")
            }
        case 4:
            localArray.append(condition)
        case 5:
            if condition == "幼年"{
              ageArray.append("CHILD")
            }
            else if condition == "成年"{
              ageArray.append("ADULT")
            }
        case 6:
            if condition == "是"{
               sterilizationArray.append("T")
            }
            else if condition == "否"{
               sterilizationArray.append("F")
            }
            else if condition == "未知"{
               sterilizationArray.append("")
            }
            
        default:
            return
        }
    }
    
    func removeCondition(tag:Int,condition:String){
        switch tag {
        case 1:
            if let index = sexArray.firstIndex(of: condition){
                sexArray.remove(at: index)
            }
        case 2:
            if let index = typeArray.firstIndex(of: condition){
                typeArray.remove(at: index)
            }
        case 3:
            if let index = sizeArray.firstIndex(of: condition){
                sizeArray.remove(at: index)
            }
        case 4:
            if let index = localArray.firstIndex(of: condition){
                localArray.remove(at: index)
            }
        case 5:
            if let index = ageArray.firstIndex(of: condition){
                ageArray.remove(at: index)
            }
        case 6:
            if let index = sterilizationArray.firstIndex(of: condition){
                sterilizationArray.remove(at: index)
            }
        default:
            return
        }
    }

}

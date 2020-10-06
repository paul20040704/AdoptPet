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
var timeGapArray = Array<Double>()

class AdSearchTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    //var collectionArray : Array<String> = [""]
    var tableTag : Int = 0
    var tableTitle : String = ""
    var localIsSelect : Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(resetCollection), name: NSNotification.Name(rawValue: "reset"), object: nil)
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame.size.height = 300
        NotificationCenter.default.post(name: Notification.Name("changeNumber"), object: nil)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDic[tableTitle]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AdSearchCollectionViewCell
        cell.chooseLabel.text = totalDic[tableTitle]![indexPath.row]
        cell.tag = tableTag
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AdSearchCollectionViewCell
        if cell.tag > 0 {
            cell.chooseLabel.backgroundColor = .green
            addCondition(tag: cell.tag, condition: totalDic[tableTitle]![indexPath.row])
            cell.tag = -(cell.tag)
        }else if cell.tag < 0 {
            cell.chooseLabel.backgroundColor = .systemYellow
            cell.tag = -(cell.tag)
            removeCondition(tag: cell.tag, condition: totalDic[tableTitle]![indexPath.row])
        }
    }
    
    @objc func resetCollection(){
        for i in 0...totalDic[tableTitle]!.count - 1  {
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
            timeGapArray.removeAll()
           
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
        case 7:
            if condition == "三天"{
                timeGapArray.append(259200)
            }
            else if condition == "一週"{
                timeGapArray.append(604800)
            }
            else if condition == "一月"{
                timeGapArray.append(2592000)
            }
            else if condition == "半年"{
                timeGapArray.append(15552000)
            }
        default:
            return
        }
        NotificationCenter.default.post(name: Notification.Name("changeNumber"), object: nil)
    }
    
    func removeCondition(tag:Int,condition:String){
        var conditionValue = ""
        var conditionDouble = 0.0
        switch tag {
        case 1:
            if condition == "公"{
                conditionValue = "M"
            }else if condition == "母"{
                conditionValue = "F"
            }
            if let index = sexArray.firstIndex(of: conditionValue){
                sexArray.remove(at: index)
            }
        case 2:
            if let index = typeArray.firstIndex(of: condition){
                typeArray.remove(at: index)
            }
        case 3:
            if condition == "大型"{
                conditionValue = "BIG"
            }else if condition == "中型"{
                conditionValue = "MEDIUM"
            }else if condition == "小型"{
                conditionValue = "SMALL"
            }
            if let index = sizeArray.firstIndex(of: conditionValue){
                sizeArray.remove(at: index)
            }
        case 4:
            if let index = localArray.firstIndex(of: condition){
                localArray.remove(at: index)
            }
        case 5:
            if condition == "幼年"{
                conditionValue = "CHILD"
                }else if condition == "成年"{
                conditionValue = "ADULT"
                }
            if let index = ageArray.firstIndex(of: conditionValue){
                ageArray.remove(at: index)
            }
        case 6:
            if condition == "是"{
                conditionValue = "T"
            }else if condition == "否"{
                conditionValue = "F"
            }else if condition == "未知"{
                conditionValue = ""
            }
            if let index = sterilizationArray.firstIndex(of: conditionValue){
                sterilizationArray.remove(at: index)
            }
        case 7:
            if condition == "三天"{
                conditionDouble = 259200
            }else if condition == "一週"{
                conditionDouble = 604800
            }else if condition == "一月"{
                conditionDouble = 2592000
            }else if condition == "半年"{
                conditionDouble = 15552000
            }
            if let index = timeGapArray.firstIndex(of: conditionDouble){
                timeGapArray.remove(at: index)
            }
            
        default:
            return
        }
        NotificationCenter.default.post(name: Notification.Name("changeNumber"), object: nil)
    }

}

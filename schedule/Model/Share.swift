//
//  public.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Share : NSObject{
    static let shared = Share()
    
    func alertVC(message: String ,title : String) -> UIAlertController{
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        alertView.addAction(action)
        return alertView
    }
    
    func fileDocumentsPath(fileName: String) -> URL {
        
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let documents = homeURL.appendingPathComponent("Documents")
        let fileURL = documents.appendingPathComponent(fileName)
        return fileURL
    }
    
    func loadImage(fileName:String?) -> UIImage? {
        if let fileName = fileName{
            let fileURL = fileDocumentsPath(fileName: fileName)
            if let imageData = try? Data(contentsOf: fileURL){
                return UIImage(data: imageData)
            }
        }
        return UIImage(named: "search")
    }
    
    func downloadImage(path:String , name:String){
        DispatchQueue.global().async {
            let fileName = "\(name).jpg"
            print(fileName)
            let filePath = US.fileDocumentsPath(fileName: fileName)
            if let imgUrl = URL(string: path){
                do{
                    let imgData = try Data(contentsOf: imgUrl)
                    try imgData.write(to: filePath)
                }catch{
                    print("\(name) : catch imageData fail..")
                }
            }else{
                print("\(name) : analysis imageUrl fail..")
            }
        }
    }
    
    func judgeImage(fileName:String) -> Bool{
        let fileURL = fileDocumentsPath(fileName: fileName)
        if let imageData = try? Data(contentsOf: fileURL){
            return true
        }else{
            return false
        }
    }
    //取得最上方的view
    func getCurrentViewController() -> UIViewController?{
    if let rootVC = UIApplication.shared.keyWindow?.rootViewController{
        var currentController : UIViewController! = rootVC
        while( currentController.presentedViewController != nil ) {
            currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
     }

    //搜尋條件結果
    func search() -> [RLM_ApiData]{
        var infoArr : [RLM_ApiData] = []
        let realm = try! Realm()
        let orders = realm.objects(RLM_ApiData.self)
        for order in orders {
            var conditionFound = true
            if sexArray.count > 0{
                if !(sexArray.contains(order.animal_sex)){
                    conditionFound = false
                }
            }
            if typeArray.count > 0{
                if !(typeArray.contains(order.animal_kind)){
                    conditionFound = false
                }
            }
            if sizeArray.count > 0{
                if !(sizeArray.contains(order.animal_bodytype)){
                    conditionFound = false
                }
            }
            if localArray.count > 0{
                var localCondition = false
                for local in localArray{
                    if order.shelter_address.contains(local){
                        localCondition = true
                        }
                    }
                    if !(localCondition){
                        conditionFound = false
                    }
            }
            if ageArray.count > 0{
                if !(ageArray.contains(order.animal_age)){
                    conditionFound = false
                }
            }
            if sterilizationArray.count > 0{
                if !(sterilizationArray.contains(order.animal_sterilization)){
                    conditionFound = false
                }
            }
            if conditionFound {
                infoArr.append(order)
            }
        }
        return infoArr
    }
    
    




}





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
import Alamofire
import SwiftyJSON

class Share : NSObject{
    static let shared = Share()
    
    func alertVC(message: String ,title : String) -> UIAlertController{
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
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
    //取得現在時間
    func getTimeStampToDouble() -> Double {
        let d = Date()
        let timeInterval:TimeInterval = d.timeIntervalSince1970
        return floor(timeInterval)
    }
    //日期轉換String
    func dateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
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
    
    func updateApiData(type:Int ,completion: @escaping(_ finish: Bool) -> ()){
        if let r = try? Realm(){
            let gapTime = US.getTimeStampToDouble() - UD.double(forKey: UPD)
            if(type == 1 && gapTime < 84000){
                completion(true)
            }
            if(type == 0){
                try? r.write {
                    let apiDatas = r.objects(RLM_ApiData.self)
                    let lostDatas = r.objects(RLM_LostApi.self)
                    r.delete(apiDatas)
                    r.delete(lostDatas)
                    UD.set(US.getTimeStampToDouble(), forKey: UPD)
                }
            }
        }//end realm
        let group = DispatchGroup()
        group.enter()
        getAdoptData { (finish) in
            if finish{
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(true)
        }
    }
    
    func getAdoptData(completion: @escaping(_ finish: Bool) -> ()){
        if let r = try? Realm(){
            let url = "https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL"
            var i = 0
            Alamofire.request(url).responseJSON { (response) in
                if response.result.isSuccess {
                    do {
                        let json = try JSON(data:response.data!)
                        if let result = json.array{
                            try? r.write {
                                for data in result{
                                    i += 1
                                    var aniArray = [String]()
                                    if data["album_file"] != ""{
                                        aniArray.append(data["animal_id"].stringValue)
                                        aniArray.append(data["animal_subid"].stringValue)
                                        aniArray.append(data["animal_area_pkid"].stringValue)
                                        aniArray.append(data["animal_shelter_pkid"].stringValue)
                                        aniArray.append(data["animal_place"].stringValue)
                                        aniArray.append(data["animal_kind"].stringValue)
                                        aniArray.append(data["animal_sex"].stringValue)
                                        aniArray.append(data["animal_bodytype"].stringValue)
                                        aniArray.append(data["animal_colour"].stringValue)
                                        aniArray.append(data["animal_age"].stringValue)
                                        aniArray.append(data["animal_sterilization"].stringValue)
                                        aniArray.append(data["animal_bacterin"].stringValue)
                                        aniArray.append(data["animal_foundplace"].stringValue)
                                        aniArray.append(data["animal_title"].stringValue)
                                        aniArray.append(data["animal_status"].stringValue)
                                        aniArray.append(data["animal_remark"].stringValue)
                                        aniArray.append(data["animal_caption"].stringValue)
                                        aniArray.append(data["animal_opendate"].stringValue)
                                        aniArray.append(data["animal_closeddate"].stringValue)
                                        aniArray.append(data["animal_update"].stringValue)
                                        aniArray.append(data["animal_createtime"].stringValue)
                                        aniArray.append(data["shelter_name"].stringValue)
                                        aniArray.append(data["album_file"].stringValue)
                                        aniArray.append(data["album_update"].stringValue)
                                        aniArray.append(data["cDate"].stringValue)
                                        aniArray.append(data["shelter_address"].stringValue)
                                        aniArray.append(data["shelter_tel"].stringValue)
                                        r.create(RLM_ApiData.self, value: aniArray, update: true)
                                        //下載圖片100筆
                                        if i < 100 {
                                            if US.judgeImage(fileName: "\(data["animal_id"].stringValue).jpg"){
                                                continue
                                            }
                                            US.downloadImage(path: data["album_file"].stringValue, name:data["animal_id"].stringValue)
                                        }
                                    }
                                }
                            }
                        completion(true)
                    }
                }catch{
                    completion(false)
                    print("response data fail..")
                }
            }else{
                completion(false)
                print("json null..")
                    }
                }
            }
        }
    



    
    
    
    
    
}




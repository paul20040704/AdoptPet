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
        return UIImage(named: "noImage")
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
    
    //Date轉Double
    func setTimeStampToDouble(date:Date) -> Double {
        let timeInterval:TimeInterval = date.timeIntervalSince1970
        return floor(timeInterval)
    }
    
    //日期轉換String
    func dateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    //日期String轉Date
    func stringToDate(string:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: string){
            return date
        }else{
            return Date()
        }
    }
    //計算要顯示的條件陣列
    func showConditionArr() -> Array<String>{
        var condArr = Array<String>()
        if sexArray.count == 1 {
            switch sexArray[0] {
            case "M":
                condArr.append("公")
            default:
                condArr.append("母")
            }
        }
        if typeArray.count == 1 {
            condArr.append(typeArray[0])
        }
        if sizeArray.count == 1{
            switch sizeArray[0] {
            case "SMALL":
                condArr.append("小型")
            case "MEDIUM":
                condArr.append("中型")
            default:
                condArr.append("大型")
            }
        }
        if sizeArray.count > 1{
            condArr.append("多種體型")
        }
        if localArray.count == 1{
            condArr.append(localArray[0])
        }
        if localArray.count > 1{
            condArr.append("多個地區")
        }
        if ageArray.count == 1{
            switch ageArray[0] {
            case "ADULT":
                condArr.append("成年")
            default:
                condArr.append("幼年")
            }
        }
        if sterilizationArray.count == 1{
            switch sterilizationArray[0] {
            case "T":
                condArr.append("已絕育")
            case "F":
                condArr.append("未絕育")
            default:
                condArr.append("絕育未知")
            }
        }
        if timeGapArray.count > 0{
            switch timeGapArray.max() {
            case 259200:
                condArr.append("三天前")
            case 604800:
                condArr.append("一週前")
            case 2592000:
                condArr.append("一月前")
            default:
                condArr.append("半年前")
            }
        }
        return condArr
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
            if timeGapArray.count > 0 {
                let gap = timeGapArray.max()
                let catchDate = stringToDate(string: order.cDate)
                let catchDouble = setTimeStampToDouble(date: catchDate)
                let nowDouble = getTimeStampToDouble()
                if (nowDouble - catchDouble) > gap! {
                    conditionFound = false
                }
            }
            
            if conditionFound {
                infoArr.append(order)
            }
        }
        return infoArr
    }
    
    func getAdoptData(type:Int, completion: @escaping(_ finish: Bool) -> ()){
        if let r = try? Realm(){
            //清除舊的DB資料
            let gapTime = US.getTimeStampToDouble() - UD.double(forKey: UPD)
            if(type == 1 && gapTime < 86400){
                completion(true)
            }
            if(type == 0){
                try? r.write {
                    let apiDatas = r.objects(RLM_ApiData.self)
                    r.delete(apiDatas)
                    UD.set(US.getTimeStampToDouble(), forKey: UPD)
                }
            }
            //開始Loading
            print("***** start get API")
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
                    CTAlertView.ctalertView.showAlert(title: "提醒", body: "無法找到資料，麻煩稍後再嘗試", action: "確認")
                    print("response data fail..")
                }
            }else{
                completion(false)
                print("json null..")
                CTAlertView.ctalertView.showAlert(title: "提醒", body: "無法找到資料，麻煩稍後再嘗試", action: "確認")
                    }
                }
            }
        }
    
    func goMain(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let mainTBC = sb.instantiateViewController(withIdentifier: "mainTBC")
        appDelegate.window?.rootViewController = mainTBC
    }
    
    

    
    
}





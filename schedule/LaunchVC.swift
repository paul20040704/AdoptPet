//
//  LaunchVC.swift
//  schedule
//
//  Created by TimeCity on 2019/10/8.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Reachability

class LaunchVC: UIViewController {
    let reachability = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
     let url = "https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL"
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                do {
                    let json = try JSON(data:response.data!)
                    if let result = json.array{
                        if let r = try? Realm(){
                            try? r.write {
                                for data in result{
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
                                    }
                                }
                            }
                        }
                    }
                    self.goMainTBC()
                }catch{
                    print("response data fail..")
                }
            }else{
                print("json null..")
            }
        })
            
        }//DispathQueue
        
    }
   
    func goMainTBC(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let mainTBC = sb.instantiateViewController(withIdentifier: "mainTBC")
        appDelegate.window?.rootViewController = mainTBC
    }
    
    
    
    
    
    
    
    
    
    

   

}

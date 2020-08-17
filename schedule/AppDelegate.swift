//
//  AppDelegate.swift
//  schedule
//
//  Created by TimeCity on 2019/9/27.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import AKSideMenu
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBQ1zsYnFa0IH-LLz_5FGWuu88bngMavtk")
        // Override point for customization after application launch.
        let url = "https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL"
        var i = 0
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                do {
                    let json = try JSON(data:response.data!)
                    if let result = json.array{
                        if let r = try? Realm(){
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
                                        if US.judgeImage(fileName: "\(data["animal_id"].stringValue).jpg"){
                                            continue
                                        }
                                        let fileURL = US.fileDocumentsPath(fileName: data["animal_id"].stringValue)
                                        r.create(RLM_ApiData.self, value: aniArray, update: true)
                                        //下載圖片100筆
                                        if i < 100{
                                        US.downloadImage(path: data["album_file"].stringValue, name:data["animal_id"].stringValue)
                                            print("\(i)")
                                        }
                                    }
                                }
                           }
                        }
                    }
                }catch{
                    print("response data fail..")
                }
            }else{
                print("json null..")
            }
            self.goMain()
        })
        
        //NotificationCenter.default.post(name: Notification.Name("goMainTBC"), object: nil)
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func goMain(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let mainTBC = sb.instantiateViewController(withIdentifier: "mainTBC")
        appDelegate.window?.rootViewController = mainTBC
    }
    

}


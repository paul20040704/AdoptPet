//
//  AppDelegate.swift
//  schedule
//
//  Created by TimeCity on 2019/9/27.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import AKSideMenu
import GoogleMaps
import PKHUD
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyBQ1zsYnFa0IH-LLz_5FGWuu88bngMavtk")
        UINavigationBar.appearance().backgroundColor = .blue
        //初始化時間UD
        if UD.object(forKey: UPD) == nil {
             UD.set(US.getTimeStampToDouble(), forKey: UPD)
             UD.synchronize()
         }
        let gapTime = US.getTimeStampToDouble() - UD.double(forKey: UPD)
        US.updateData(type: 1 ,gapTime: gapTime) { (finish) in
            self.goMain()
        }
        
        
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
        HUD.show(.label("更新資料中"))
        let gapTime = US.getTimeStampToDouble() - UD.double(forKey: UPD)
            US.updateData(type: 1,gapTime: gapTime) { (finish) in
                if finish  {
                    HUD.hide()
                }
            }
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


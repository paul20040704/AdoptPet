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
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyBQ1zsYnFa0IH-LLz_5FGWuu88bngMavtk")
        //UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 0.9972601472, blue: 0.7642197333, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //初始化時間UD
        if UD.object(forKey: UPD) == nil {
             UD.set(US.getTimeStampToDouble(), forKey: UPD)
             UD.synchronize()
            
         }
        //NotificationCenter.default.post(name: Notification.Name("goMainTBC"), object: nil)
        checkVersion()
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
            US.getAdoptData(type: 1) { (finish) in
                    HUD.hide()
            }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    func checkVersion() {
        if let infoDictionary = Bundle.main.infoDictionary {
            
            guard let bundleVersionStr = infoDictionary["CFBundleVersion"] as? String else {return}
            let bundleVersion = Float(bundleVersionStr)
            
            let databaseRef = Database.database().reference().child("AppVersion")
            databaseRef.observe(.value) { data in
                guard let version = data.value as? Float else {return}
                if version > bundleVersion! {
                    if let rootVC = self.window?.rootViewController {
                        let alertVC = UIAlertController(title: "提醒", message: "\n本程式有最新版本是否前往更新?\n", preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "是", style: .destructive) { action in
                            guard let url = URL(string: "https://apps.apple.com/us/app/%E5%B9%AB%E7%89%A0%E6%89%BE%E5%80%8B%E5%AE%B6/id1579290925#?platform=iphone") else{return}
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
                        alertVC.addAction(ok)
                        alertVC.addAction(cancel)
                        rootVC.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    

}


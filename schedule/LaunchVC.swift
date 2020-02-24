//
//  LaunchVC.swift
//  schedule
//
//  Created by TimeCity on 2019/10/8.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import Reachability

class LaunchVC: UIViewController {
    let reachability = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goMainTBC), name: Notification.Name("goMainTBC") , object: nil)
    }
   
    @objc func goMainTBC(){
        print("goMainTBC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let mainTBC = sb.instantiateViewController(withIdentifier: "mainTBC")
        appDelegate.window?.rootViewController = mainTBC
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

   

}

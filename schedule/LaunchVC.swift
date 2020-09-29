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
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        checkNetwork()
    }
   
    func checkNetwork(){
        DispatchQueue.main.async {
            
            self.reachability!.whenReachable = { reachability in
                
                US.updateApiData(type: 0) { (finish) in
                    if finish {
                        US.goMain()
                    }
                }
            }
            
            self.reachability?.whenUnreachable = { reachability in
                print("No Network Connect")
                let alertVC = UIAlertController(title: "提醒", message: "無法連上網路", preferredStyle: .alert)
                let action = UIAlertAction(title: "重新加載", style: .default) { (action) in
                    alertVC.dismiss(animated: true, completion: nil)
                    self.reachability = try! Reachability()
                    self.checkNetwork()
                }
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            do {
                try self.reachability!.startNotifier()
            } catch {
                debugPrint("Unable to start notifier")
            }
            
            
            self.reachability!.stopNotifier()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

   

}

//
//  HomeVC.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/11/2.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseStorage

class HomeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    
    func getChat(){
    }
   

}

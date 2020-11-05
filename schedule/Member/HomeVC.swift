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
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        getUserInfo()
        
        print("* name \(Auth.auth().currentUser?.displayName)")
        print("*456 \(Auth.auth().currentUser?.uid)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    
    func getUserInfo() {
        if Auth.auth().currentUser!.displayName != nil{
            self.userLab.text = Auth.auth().currentUser!.displayName
            return
        }
        let databaseRef = Database.database().reference().child("User").child(Auth.auth().currentUser!.uid)
        databaseRef.observe(.value) { (user) in
            if let userData = user.value as? [String:String] {
                self.userLab.text = userData["name"]
            }
        }
    }
    
   
    @IBAction func logout(_ sender: Any) {
        print("logout")
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
}

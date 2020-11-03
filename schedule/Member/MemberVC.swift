//
//  MemberVC.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/10/30.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import Firebase


class MemberVC: UIViewController ,UITextFieldDelegate{
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                let alert = UIAlertController.init(title: "提醒", message: "登入成功", preferredStyle:.alert)
                let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                    let sb = UIStoryboard.init(name: "Member", bundle: Bundle.main)
                    let HomeVC = sb.instantiateViewController(withIdentifier: "Home") as! HomeVC
                    self.present(HomeVC, animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                let alert = US.alertVC(message: "帳號或密碼錯誤", title: "登入失敗")
                self.present(alert, animated: true, completion: nil)
                return
                print("Login Error")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}

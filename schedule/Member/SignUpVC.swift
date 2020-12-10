//
//  SignUpVC.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/10/30.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

protocol SignUpDelegate {
    func signUp(emailAccount:String,password:String)
}
class SignUpVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var delegate : SignUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.delegate = self
        mailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func signUp(_ sender: Any) {
        if nameTF.text == ""{
            let alertVC = US.alertVC(message: "請填寫名稱", title: "提醒")
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        if mailTF.text == "" {
            let alertVC = US.alertVC(message: "請填寫註冊信箱", title: "提醒")
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        if passwordTF.text == "" || passwordTF.text!.count < 6 {
            let alertVC = US.alertVC(message: "密碼小於6個", title: "提醒")
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        HUD.show(.label("註冊中..."))
        Auth.auth().createUser(withEmail: mailTF.text!, password: passwordTF.text!) { (user, error) in
            if error == nil {
                self.delegate?.signUp(emailAccount: self.mailTF.text!,password:self.passwordTF.text!)
                print("FireBase帳號註冊成功")
                let uid = Auth.auth().currentUser!.uid
                let accountDic = ["uid":uid, "mail":self.mailTF.text!, "name":self.nameTF.text] as [String : Any]
                Database.database().reference().child("User").child("\(uid)").setValue(accountDic)
                HUD.hide()
                let alert = UIAlertController.init(title: "提醒", message: "註冊成功", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else{
                print("註冊失敗 : \(error)")
                HUD.hide()
                let alert = US.alertVC(message: "註冊失敗", title: "請換一個信箱試試")
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

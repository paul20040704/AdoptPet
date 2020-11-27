//
//  MemberVC.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/10/30.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class MemberVC: UIViewController, UITextFieldDelegate, SignUpDelegate, GIDSignInDelegate{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var BGView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        // Google Sign
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        BGView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        BGView.alpha = 0.5
        BGView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        let layer = CAGradientLayer()
        
    }
    
    func signUp(emailAccount: String,password:String) {
        email.text = emailAccount
        self.password.text = password
    }
    

    @IBAction func login(_ sender: Any) {
        self.view.addSubview(BGView)
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                let alert = UIAlertController.init(title: "提醒", message: "登入成功", preferredStyle:.alert)
                let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                    self.email.text = ""
                    self.password.text = ""
                    self.dismiss(animated: true, completion: nil)
                    self.BGView.removeFromSuperview()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                let alert = US.alertVC(message: "帳號或密碼錯誤", title: "登入失敗")
                self.present(alert, animated: true, completion: nil)
                self.BGView.removeFromSuperview()
                return
                print("Login Error")
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Member", bundle: Bundle.main)
        let signVC = sb.instantiateViewController(withIdentifier: "Sign") as! SignUpVC
        signVC.delegate = self
        self.present(signVC, animated: true, completion: nil)
        
    }
    
    @IBAction func signGoogle(_ sender: Any) {
        self.view.addSubview(BGView)
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func signFacebook(_ sender: Any) {
        self.view.addSubview(BGView)
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile","email"], viewController: self) { (loginResult) in
            switch loginResult {
            case .cancelled:
                print("FB login cancel")
                self.BGView.removeFromSuperview()
                return
            case .failed(let error):
                print("FB login fail \(error.localizedDescription)")
                return
            case .success(granted: let granted, declined: let declined, token: let accessToken):
                if AccessToken.current == nil{
                    print("failed to get access token")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credential) { (user, error) in
                        
                        if error != nil {
                            print(error?.localizedDescription)
                            return
                        }
                        NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                        self.BGView.removeFromSuperview()
                        self.dismiss(animated: true, completion: nil)
                    }
            }
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    //GoogleSignIn Delegate 
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            if let userName = user.profile.name {
                if let auth = user.authentication {
                    let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
                    Auth.auth().signIn(with: credential) { (firebaseUser, error) in
                        if error == nil {
                            print("Google 登入成功")
                            NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                            self.BGView.removeFromSuperview()
                        }else{
                            print(error?.localizedDescription)
                            let alert = US.alertVC(message: "Google 登入失敗", title: "提醒")
                            self.present(alert, animated: true, completion: nil)
                            self.BGView.removeFromSuperview()
                            return
                        }
                    }
                }
            }
        }else{
            self.BGView.removeFromSuperview()
            print(error.localizedDescription)
        }
      }
}

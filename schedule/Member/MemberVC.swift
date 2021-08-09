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
import AuthenticationServices
import CryptoKit
import FirebaseFirestore

class MemberVC: UIViewController, UITextFieldDelegate, SignUpDelegate, GIDSignInDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var BGView = UIView()
    @IBOutlet weak var appleBtn: UIButton!
    fileprivate var currentNonce: String?
    
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
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityView.center = BGView.center
        activityView.startAnimating()
        activityView.style = .white
        BGView.addSubview(activityView)
        
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
    @available(iOS 13.0, *)
    @IBAction func signApple(_ sender: Any) {
        self.view.addSubview(BGView)
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    @available(iOS 13, *)
       private func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
               return String(format: "%02x", $0)
           }.joined()
           
           return hashString
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
    
    // Firebase AppleID 登入
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      return result
    }
    
    
}


@available(iOS 13.0, *)
extension MemberVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    self.BGView.removeFromSuperview()
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? "私人apple帳號"
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let accountDic = ["uid":uid, "mail":email , "name":displayName ] as [String : Any]
                Database.database().reference().child("User").child("\(uid)").setValue(accountDic)
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                self.BGView.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.BGView.removeFromSuperview()
        print("Sign in with Apple errored: \(error)")
    }
}

@available(iOS 13.0, *)
extension MemberVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

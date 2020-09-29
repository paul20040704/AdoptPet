//
//  LostPostViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/7.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import SnapKit
import ImagePicker
import FirebaseStorage
import FirebaseDatabase
import PKHUD
import Lightbox
import Reachability

class LostPostViewController: UIViewController , UITextViewDelegate, ImagePickerDelegate , LightboxControllerDismissalDelegate {
    
    @IBOutlet weak var chooseKind: UIButton!
    @IBOutlet var kindOptions: [UIButton]!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet var photoBtn: [UIButton]!
    var remarkLabel = UILabel()
    let imagePicker = ImagePickerController()
    var selectPhotos = [UIImage]()
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var netLabel: UILabel!
    var reachability = try! Reachability()
    var netPossible = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
        self.isModalInPresentation = true
        }
        
        self.reachability?.whenReachable = { reachability in
            self.netLabel.isHidden = true
            self.netPossible = true
            }
               
        self.reachability?.whenUnreachable = { reachability in
            self.netLabel.isHidden = false
            self.netPossible = false
            }
               
        do {
            try self.reachability!.startNotifier()
            } catch {
                debugPrint("Unable to start notifier")
            }
        
        
        remarkLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 250, height: 20))
        remarkLabel.text = "特徵 : 如晶片號碼、毛色、體型、性別等。"
        remarkLabel.font = UIFont(name:"Helvetica-Light", size: 12)
        remarkLabel.textColor = .gray
        
        remarkTextView.addSubview(remarkLabel)
        remarkTextView.delegate = self
        remarkTextView.resignFirstResponder()
        remarkTextView.returnKeyType = .done
        contactField.returnKeyType = .done
        placeField.returnKeyType = .done
        
        dateBtn.setTitle(US.dateToString(date: Date()), for: .normal)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func kindSelect(_ sender: Any) {
        chooseKind.setTitle("選擇種類", for: .normal)
        for option in kindOptions {
            UIView.animate(withDuration: 0.3) {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func kindBtnPress(_ sender: UIButton) {
        chooseKind.setTitle(sender.titleLabel?.text, for: .normal)
        for option in kindOptions{
            option.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            remarkLabel.isHidden = false
        }else{
            remarkLabel.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            self.view.endEditing(false)
            return false
        }
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        remarkTextView.resignFirstResponder()
        self.view.endEditing(false)
    }

    @IBAction func chooseDate(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(8)
        }
        
        let ok = UIAlertAction(title: "確定", style: .default) { (action) in
            let dateString = US.dateToString(date: datePicker.date)
            self.dateBtn.setTitle(dateString, for: .normal)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert,animated: true, completion: nil)
        
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        let config = Configuration()
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true

        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        imagePicker.imageLimit = 3
        imagePicker.modalPresentationStyle = .fullScreen
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else{return}
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        lightbox.modalPresentationStyle = .fullScreen
        lightbox.dynamicBackground = true
        imagePicker.present(lightbox,animated: true,completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let number = images.count
        for i in 0...number - 1{
            photoBtn[i].setImage(images[i], for: .normal)
            selectPhotos = images
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: Any) {
        if netPossible == false {
            let alertVC = US.alertVC(message: "請確認是否連上網路", title: "提醒")
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        HUD.show(.label("上傳中..."))
        //判斷條件
        if contactField.text == ""{
            let alertVC = US.alertVC(message: "聯絡方式不可為空", title: "提醒")
            self.present(alertVC,animated: true,completion: nil)
            HUD.hide()
            return
        }
        if selectPhotos.count == 0{
            let alertVC = US.alertVC(message: "至少上傳一張照片", title: "提醒")
            self.present(alertVC,animated: true,completion: nil)
            HUD.hide()
            return
        }
        var kind = ""
        switch chooseKind.titleLabel?.text {
        case "貓":
            kind = "貓"
        case "狗":
            kind = "狗"
        default:
            kind = ""
        }
        //隨機生成7位數
        let postID = String(Int(arc4random_uniform(8999999) + 1000000))
        
        getImagePath { (imagePaths) in
            guard  let remark = self.remarkTextView.text, let pickDate = self.dateBtn.titleLabel?.text, let contact = self.contactField.text, let place = self.placeField.text  else {return}
            let postDataItem = PostData(kind: kind, remark: remark, pickDate: pickDate, contact: contact, plcae: place, photoArray: imagePaths)
            let databaseRef = Database.database().reference().child("LostPostUpload").child(postID)
            databaseRef.setValue(postDataItem.toAnyObject()) { (error, dataRef) in
            if error != nil {
                print("Database Error :\(String(describing: error?.localizedDescription))")
                let alertVC = US.alertVC(message: "上傳失敗", title: "提醒")
                HUD.hide()
                self.present(alertVC,animated: true,completion: nil)
                }else{
                 HUD.hide()
                 self.chooseKind.setTitle("選擇種類", for: .normal)
                 self.remarkTextView.text = ""
                 self.dateBtn.setTitle(US.dateToString(date: Date()), for: .normal)
                 self.contactField.text = ""
                 self.placeField.text = ""
                 for i in 0...2 {
                    self.photoBtn[i].setImage(UIImage.init(named: "AddPhoto"), for: .normal)
                 }
                 let alertVC = US.alertVC(message: "上傳成功", title: "提醒")
                 self.present(alertVC,animated: true,completion: nil)
                }
            }
        }
    }
    
    func  getImagePath(completion: @escaping (_ imagePaths :Array<String>) ->()){
        var imageUrlArray = Array<String>()
        let index = selectPhotos.count - 1
        for i in 0...index {
            let image = selectPhotos[i]
            let uniqueString = UUID().uuidString
            let storageRef = Storage.storage().reference().child("LostPostUpload").child("\(uniqueString).png")
            if let uploadData = image.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (data, error) in
                    if error != nil{
                        print("Error :\(String(describing: error?.localizedDescription))")
                        let alertVC = US.alertVC(message: "上傳失敗", title: "提醒")
                        self.present(alertVC,animated: true,completion: nil)
                        HUD.hide()
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else{
                            return
                        }
                        imageUrlArray.append(downloadURL.absoluteString)
                        if imageUrlArray.count == index + 1{
                            completion(imageUrlArray)
                        }
                    }
                }
            }
        }
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        controller.dismiss(animated: true, completion: nil)
       }
 
    
    
    
}



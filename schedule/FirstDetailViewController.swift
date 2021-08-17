//
//  FirstDetailViewController.swift
//  schedule
//
//  Created by TimeCity on 2019/10/15.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit

class FirstDetailViewController: UIViewController {

    var infoDetail = RLM_ApiData()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sterilizationLabel: UILabel!
    @IBOutlet weak var bacterinLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var foundLabel: UILabel!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    var sterilization = ""
    var sex = ""
    var type = ""
    var bacterin = ""
    var age = ""
    var cellImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        judge()
        self.navigationItem.title = "等待領養"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "upload"), style: .plain, target: self, action: #selector(share))
        if let  image = US.loadImage(fileName: "\(infoDetail.animal_id).jpg"){
            cellImage = image
        }
        imageView.image = cellImage.scaleImage(scaleSize: 0.5)
        ageLabel.text = "年齡     : \(age)"
        idLabel.text = "ID  : \(infoDetail.animal_id)"
        sterilizationLabel.text =    "是否絕育    : \(sterilization)"
        bacterinLabel.text = "是否疫苗    : \(bacterin)"
        kindLabel.text =  "種類     : \(infoDetail.animal_kind)"
        sexLabel.text =   "性別     : \(sex)"
        typeLabel.text =  "體型     : \(type)"
        colorLabel.text = "顏色     : \(infoDetail.animal_colour)"
        foundLabel.text = "發現地   : \(infoDetail.animal_foundplace)"
        createLabel.text = "發現日   : \(infoDetail.animal_createtime)"
        addressLabel.text = "收容所地址 : \(infoDetail.shelter_address)"
        telLabel.text =   "聯繫收容所 : \(infoDetail.shelter_tel)"
        remarkLabel.text = "備註     : \(infoDetail.animal_remark)"
        openLabel.text = "開放領養日期 : \(infoDetail.animal_opendate)"
        updateLabel.text = "資料更新日期 : \(infoDetail.animal_update)"
        
        
        setTap()
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let googleMapVC = segue.destination as! GoogleMapViewController
        googleMapVC.pickAddress = infoDetail.shelter_address
    }
    
    func judge(){
        switch infoDetail.animal_sterilization {
        case "T":
           sterilization = "是"
        case "F":
           sterilization = "否"
        default:
           sterilization = "未知"
        }
        
        switch infoDetail.animal_sex {
        case "M":
            sex = "公"
        case "F":
            sex = "母"
        default:
            sex = "未知"
        }
        
        switch infoDetail.animal_bodytype {
        case "BIG":
            type = "大型"
        case "SMALL":
            type = "小型"
        case "MEDIUM":
            type = "中型"
        default:
            type = "未知"
        }
        
        switch infoDetail.animal_bacterin {
        case "T":
           bacterin = "是"
        case "F":
           bacterin = "否"
        default:
           bacterin = "未知"
        }
        
        switch infoDetail.animal_age {
        case "ADULT":
           age = "成年"
        case "CHILD":
           age = "幼年"
        default:
           bacterin = "未知"
        }
    }
    
    @objc func share() {
        let urlString = URL(string: "https://apps.apple.com/us/app/%E5%B9%AB%E7%89%A0%E6%89%BE%E5%80%8B%E5%AE%B6/id1579290925#?platform=iphone")
        let item = [imageView.image,"App下載連結",urlString] as [Any]
        let activityVC = UIActivityViewController(activityItems: item, applicationActivities: [CustomActivity()])
        self.present(activityVC,animated: true,completion: nil)
    }

    func setTap(){
        let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(showScrollImage))
        imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(imageTap)
        
        let telTap = UITapGestureRecognizer(target: self, action: #selector(phoneCall(recognizer:)))
        telLabel.isUserInteractionEnabled = true
        telLabel.addGestureRecognizer(telTap)
    }
    
    @objc func showScrollImage() {
        let scrollImageVC = ScrollImageVC()
        scrollImageVC.cachedImage = cellImage
        self.present(scrollImageVC, animated: true, completion: nil)
    }
    
    @objc func phoneCall(recognizer:UITapGestureRecognizer){
        if let telUrl = URL(string: "tel://\(infoDetail.shelter_tel)"){
            UIApplication.shared.open(telUrl, options: [:], completionHandler: nil)
        }
        
    }
    
}


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
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var foundLabel: UILabel!
    @IBOutlet var createLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellImage = US.loadImage(fileName: "\(infoDetail.animal_id).jpg")
        imageView.image = cellImage?.scaleImage(scaleSize: 0.5)
        idLabel.text =    "編號      : \(infoDetail.animal_id)"
        placeLabel.text = "所在地    : \(infoDetail.animal_place)"
        kindLabel.text =  "種類     : \(infoDetail.animal_kind)"
        sexLabel.text =   "性別     : \(infoDetail.animal_sex)"
        typeLabel.text =  "體型     : \(infoDetail.animal_bodytype)"
        colorLabel.text = "顏色     : \(infoDetail.animal_colour)"
        foundLabel.text = "發現地   : \(infoDetail.animal_foundplace)"
        createLabel.text = "發現日   : \(infoDetail.animal_createtime)"
        addressLabel.text = "收容所地址 : \(infoDetail.shelter_address)"
        telLabel.text =   "聯繫收容所 : \(infoDetail.shelter_tel)"
        remarkLabel.text = "備註     : \(infoDetail.animal_remark)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nderrevevevre"
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(phoneCall(recognizer:)))
        telLabel.isUserInteractionEnabled = true
        telLabel.addGestureRecognizer(tap)
        
        
    }
    
    @objc func phoneCall(recognizer:UITapGestureRecognizer){
        if let telUrl = URL(string: "tel://\(infoDetail.shelter_tel)"){
            UIApplication.shared.open(telUrl, options: [:], completionHandler: nil)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let googleMapVC = segue.destination as! GoogleMapViewController
        googleMapVC.pickAddress = infoDetail.shelter_address
    }

}

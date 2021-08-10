//
//  CustomAlertView.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/30.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import Foundation
import UIKit

class CTAlertView : UIView {
    static let ctalertView = CTAlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        parentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }
    
    func showAlert(title:String, body:String, action:String){
        titleLabel.text = title
        bodyLabel.text = body
        actionBtn.titleLabel?.text = action
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func actionPress(_ sender: Any) {
        parentView.removeFromSuperview()
    }
    
    
}

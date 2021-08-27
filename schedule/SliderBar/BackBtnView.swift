//
//  BackBtnView.swift
//  schedule
//
//  Created by paul on 2021/8/26.
//  Copyright © 2021 TimeCity. All rights reserved.
//

import UIKit

class BackBtnView: UIView {

    static let backBtnView = BackBtnView()
    var superVC = UIViewController()
    
    func setBtn(superVC:UIViewController){
        self.superVC = superVC
        let backButton = UIButton(frame: CGRect(x: 20, y: 40 , width: 30, height: 30))
        backButton.setImage(UIImage(named: "cancel"), for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        superVC.view.addSubview(backButton)
    }
    
    @objc func back(){
        superVC.dismiss(animated: true, completion:nil)
    }
}

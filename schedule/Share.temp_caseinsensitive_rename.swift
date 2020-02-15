//
//  public.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import Foundation
import UIKit


class Share : NSObject{
    static let shared = Share()
    
    func alertVC(message: String ,title : String) -> UIAlertController{
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        alertView.addAction(action)
        return alertView
    }
    
    




}





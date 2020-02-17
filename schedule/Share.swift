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
    
    func fileDocumentsPath(fileName: String) -> URL {
        
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let documents = homeURL.appendingPathComponent("Documents")
        let fileURL = documents.appendingPathComponent(fileName)
        return fileURL
    }
    
    func loadImage(fileName:String?) -> UIImage? {
        if let fileName = fileName{
            let fileURL = fileDocumentsPath(fileName: fileName)
            if let imageData = try? Data(contentsOf: fileURL){
                return UIImage(data: imageData)
            }
        }
        return UIImage(named: "search")
    }
    
    
    




}





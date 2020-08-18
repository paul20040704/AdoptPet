//
//  Global.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import Foundation
import RealmSwift


let US = Share.shared

let UD = UserDefaults.standard

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenOrigin = UIScreen.main.bounds.origin

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension UIImage{
   
    func reSizeImage(reSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func scaleImage(scaleSize:CGFloat) -> UIImage{
        let reSize = CGSize.init(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    
    
}

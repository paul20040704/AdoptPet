//
//  Extension.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/9.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import Foundation
import UIKit




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

class CustomActivity : UIActivity {
    
    override class var activityCategory: UIActivity.Category {
        return .share
    }
    
    override var activityType: UIActivity.ActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivity.ActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    
    override var activityTitle: String? {
        return "領養"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "Third")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        //
    }
    
    override func perform() {
        activityDidFinish(true)
    }
}



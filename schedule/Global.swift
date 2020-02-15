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

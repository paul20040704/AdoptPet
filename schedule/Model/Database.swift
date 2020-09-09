//
//  DataBase.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/9.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import Foundation


class PostData {
    var kind : String
    var remark : String
    var pickDate : String
    var contact : String
    var place : String
    var photoArray : [String]
    
    init(kind:String, remark:String, pickDate:String, contact:String, plcae:String, photoArray:[String]) {
        self.kind = kind
        self.remark = remark
        self.pickDate = pickDate
        self.contact = contact
        self.place = plcae
        self.photoArray = photoArray
    }
    
    
    func toAnyObject() -> Any {
        return ["kind": kind, "remark": remark, "pickDate": pickDate, "contact": contact, "place": place, "photoArray": photoArray]
    }
}

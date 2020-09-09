//
//  File.swift
//  schedule
//
//  Created by TimeCity on 2019/10/9.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_ApiData : Object {
    
    @objc dynamic var animal_id : String = ""
    @objc dynamic var animal_subid : String = ""
    @objc dynamic var animal_area_pkid : String = ""
    @objc dynamic var animal_shelter_pkid : String = ""
    @objc dynamic var animal_place : String = ""
    @objc dynamic var animal_kind :String = ""
    @objc dynamic var animal_sex : String = ""
    @objc dynamic var animal_bodytype : String = ""
    @objc dynamic var animal_colour : String = ""
    @objc dynamic var animal_age : String = ""
    @objc dynamic var animal_sterilization : String = ""
    @objc dynamic var animal_bacterin : String = ""
    @objc dynamic var animal_foundplace : String = ""
    @objc dynamic var animal_title: String = ""
    @objc dynamic var animal_status : String = ""
    @objc dynamic var animal_remark : String = ""
    @objc dynamic var animal_caption : String = ""
    @objc dynamic var animal_opendate : String = ""
    @objc dynamic var animal_closeddate : String = ""
    @objc dynamic var animal_update : String = ""
    @objc dynamic var animal_createtime : String = ""
    @objc dynamic var shelter_name : String = ""
    @objc dynamic var album_file : String = ""
    @objc dynamic var album_update : String = ""
    @objc dynamic var cDate : String = ""
    @objc dynamic var shelter_address : String = ""
    @objc dynamic var shelter_tel: String = ""
    
    override static func primaryKey() -> String {
        return "animal_id"
    }
    
}

    



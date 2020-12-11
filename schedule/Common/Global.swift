//
//  Global.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import Foundation
import FirebaseStorage
import Reachability

let US = Share.shared

let UD = UserDefaults.standard

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenOrigin = UIScreen.main.bounds.origin

let totalDic = ["性別":["公","母"],"類型":["貓","狗"],"體型":["大型","中型","小型"],"地區":["臺北","新北","桃園","新竹","苗栗","臺中","彰化","雲林","嘉義","臺南","高雄","屏東","花蓮","臺東","澎湖","金門","基隆","宜蘭"],"年紀":["幼年","成年"],"絕育":["是","否","未知"],"拾獲時間":["三天","一週","一月","半年"]]
let defultColor : UIColor = UIColor.init(red: 211/255, green: 255/255, blue: 230/255, alpha: 1)
let UPD = "updateDate"

var reachability = Reachability()

var chooseArr = [""]

var userDisplayName = ""


//
//  AdvancedSearchViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/8/20.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit

class AdvancedSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var titleArr = ["性別","類型","體型","地區","年紀","絕育"]
    var totalDic = ["性別":["公","母"],"類型":["貓","狗"],"體型":["大型","中型","小型"],"地區":["台北","新北","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","台南","高雄","屏東","花蓮","台東","澎湖","金門","基隆","宜蘭"],"年紀":["幼年","成年"],"絕育":["是","否","未知"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.register(AdSearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return 300
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdSearchTableViewCell
        cell.titleLabel.text = titleArr[indexPath.row]
        //不能點擊
        //cell.isUserInteractionEnabled = false
        cell.collectionArray = totalDic[titleArr[indexPath.row]]!
        return cell
    }

   


    
    
}





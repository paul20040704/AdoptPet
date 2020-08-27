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
    var totalDic = ["性別":["公","母"],"類型":["貓","狗"],"體型":["大型","中型","小型"],"地區":["臺北","新北","桃園","新竹","苗栗","臺中","彰化","雲林","嘉義","臺南","高雄","屏東","花蓮","臺東","澎湖","金門","基隆","宜蘭"],"年紀":["幼年","成年"],"絕育":["是","否","未知"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取消向下滑動返回&&全螢幕
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
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
        cell.collectionArray = totalDic[titleArr[indexPath.row]]!
        cell.tableTag = indexPath.row + 1
        return cell
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reset(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reset"), object: nil)
        
    }
    
    @IBAction func search(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("search"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}





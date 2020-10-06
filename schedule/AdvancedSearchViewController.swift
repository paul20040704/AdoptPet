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
    
    @IBOutlet weak var searchLabel: UIButton!
    
    
    var titleArr = ["性別","類型","體型","地區","年紀","絕育","拾獲時間"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取消向下滑動返回&&全螢幕
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.register(AdSearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        NotificationCenter.default.addObserver(self, selector: #selector(changeNumber), name: NSNotification.Name(rawValue: "changeNumber"), object: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return 300
        default:
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdSearchTableViewCell
        cell.titleLabel.text = titleArr[indexPath.row]
        cell.tableTitle = titleArr[indexPath.row]
        cell.tableTag = indexPath.row + 1
        cell.collectionView.reloadData()
        return cell
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reset(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reset"), object: nil)
        changeNumber()
        
    }
    
    @IBAction func search(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("search"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeNumber(){
        let info = US.search()
        searchLabel.setTitle("總共 \(info.count) 筆資料。點擊查詢", for: .normal)
    }
    
    
}





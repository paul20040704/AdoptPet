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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.register(AdSearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdSearchTableViewCell
        cell.titleLabel.text = titleArr[indexPath.row]
        return cell
    }

   


    
    
}





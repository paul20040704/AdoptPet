//
//  SecondViewController.swift
//  schedule
//
//  Created by TimeCity on 2019/11/21.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import RealmSwift


class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var idArr = Array<String>()
    var infoArr = [RLM_ApiData]()
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.getNewId()

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("loadData") , object: nil)
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = infoArr[indexPath.row]
        let sb = UIStoryboard.init(name: "Second", bundle: Bundle.main)
        let secondDetailVC = sb.instantiateViewController(withIdentifier: "secondDetailVC") as! SecondDetailViewController
        secondDetailVC.hidesBottomBarWhenPushed = true
        secondDetailVC.infoDetail = info
        navigationController?.show(secondDetailVC, sender: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SecondTableViewCell
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") as! SecondTableViewCell
        }
        if infoArr.count > 0{
            let info = infoArr[indexPath.row]
            if let imgUrl = URL(string: info.album_file){
                    do{
                        let imgData = try Data(contentsOf: imgUrl)
                        cell.aniImage.image = UIImage(data: imgData)
                    }catch{
                        print("catch imageData fail..")
                    }
                  }//End imgUrl
                    cell.type.text = "種類 : \(info.animal_kind)"
                    cell.address.text = "位置 : \(info.shelter_address)"
                    cell.checkDate.text = "登入日期 : \(info.animal_createtime)"
            }
              return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            idArr.remove(at: indexPath.row)
            UD.set(idArr, forKey: "likeID")
            getNewId()
            self.tableView.reloadData()
        }
    }
    

    @objc func loadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //self.refreshControl.endRefreshing()
            self.getNewId()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func getNewId(){
        if let id = UD.array(forKey: "likeID") {
            idArr = id as! [String]
        }
        infoArr.removeAll()
        let realm = try! Realm()
        let orders = realm.objects(RLM_ApiData.self)
        for order in orders{
            let animalID = order.animal_id
                if idArr.contains(animalID){
                    infoArr.append(order)
                    infoArr = infoArr.removingDuplicates()
                }
        }
        //print("getInfoArrCount : \(infoArr.count)")
        self.navigationItem.title = "我的收藏送共 : \(infoArr.count) 筆"
        
        
        
        
    }
    
    
    

}

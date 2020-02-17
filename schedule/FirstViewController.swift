//
//  ViewController.swift
//  schedule
//
//  Created by TimeCity on 2019/9/27.
//  Copyright © 2019 TimeCity. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import PKHUD
import RealmSwift


class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var localTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    let localPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    var infoArr = [RLM_ApiData]()
    var localArr = ["全部地點","台北","新北","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","高雄","屏東","台東","花蓮","宜蘭","基隆","南投"]
    var typeArr = ["全部種類","貓","狗"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBtn.layer.cornerRadius = 9.0
        searchBtn.clipsToBounds = true
        searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        localPickerView.delegate = self
        localPickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        //將textFeild預設鍵盤改為pickerView
        localTextField.inputView = localPickerView
        typeTextField.inputView = typePickerView
        //將textFeild預設文字
        localTextField.text = localArr[0]
        typeTextField.text = typeArr[0]
        
        let realm = try! Realm()
        let orders = realm.objects(RLM_ApiData.self)
        if orders.count > 10{
            for order in orders{
                infoArr.append(order)
            }
        }
       
        
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoArr.count < 1{
            return 1
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FirstTableViewCell
        if infoArr.count < 1{
           var noCell = UITableViewCell.init()
            noCell.textLabel?.text = "無資訊"
            return noCell
        }
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") as! FirstTableViewCell
        }
            var info = infoArr[indexPath.row]
            if let imgUrl = URL(string: info.album_file){
                do{
                   let imgData = try Data(contentsOf: imgUrl)
                        cell.aniImage.image = UIImage(data: imgData)
                }catch{
                   print("catch imageData fail..")
                }
            }else{
                print("analysis imageUrl fail..")
            }
            cell.type.text = "種類 : \(info.animal_kind)"
            cell.address.text = "位置 : \(info.shelter_name)"
            cell.checkDate.text = "登入日期 : \(info.cDate)"
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(like(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if infoArr.count > 1{
        let info = infoArr[indexPath.row]
        let sb = UIStoryboard.init(name: "First", bundle: Bundle.main)
        let firstDetailVC = sb.instantiateViewController(withIdentifier: "firstDetailVC") as! FirstDetailViewController
        firstDetailVC.hidesBottomBarWhenPushed = true
        firstDetailVC.infoDetail = info
        navigationController?.show(firstDetailVC, sender: nil)
      }
    }
    //UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == localPickerView {
            return localArr.count
        }
        else {
            return typeArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == localPickerView{
            return localArr[row]
        }
        else{
            return typeArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        if pickerView == localPickerView{
            localTextField.text = localArr[row]
        }
        else{
            typeTextField.text = typeArr[row]
        }
    }
    
    
    
    //按下喜歡
    @objc func like (sender:UIButton){
        let info = infoArr[sender.tag]
        var idArr = [String]()
        if let id = UD.array(forKey: "likeID") {
            idArr = id as! [String]
        }
        if idArr.contains(info.animal_id){
            let alert = US.alertVC(message: "已經有收藏", title: "提醒")
            self.present(alert,animated: true,completion: nil)
        }else{
        HUD.show(.label("更新中..."))
        HUD.hide(afterDelay: 2.0)
        idArr.append(info.animal_id)
        UD.set(idArr, forKey: "likeID")
        //NotificationCenter
        NotificationCenter.default.post(name: Notification.Name("loadData"), object: nil)
        let alert = US.alertVC(message: "已加入收藏", title: "提醒")
        self.present(alert,animated: true,completion: nil)
        }
    
    }
    
    @objc func search(){
            HUD.show(.label("稍等..."))
            HUD.hide(afterDelay: 3.0)
        infoArr = []
        if let local = localTextField.text , let type = typeTextField.text {
            let realm = try! Realm()
            let orders = realm.objects(RLM_ApiData.self)
                if local == "全部地點" && type != "全部種類" {
                    for order in orders {
                    if order.animal_kind == type{
                        infoArr.append(order)
                    }
                  }
                }
                else if type == "全部種類" && local != "全部地點"  {
                    for order in orders {
                    if order.shelter_address.contains(local) {
                        infoArr.append(order)
                    }
                  }
                }
                else if local == "全部地點" && type == "全部種類"{
                    for order in orders {
                    infoArr.append(order)
                    }
                }
                else {
                    for order in orders {
                        if order.animal_kind == type && order.shelter_address.contains(local) {
                            infoArr.append(order)
                        }
                    }
                }
            }
        self.tableView.reloadData()
    }


    

    
}


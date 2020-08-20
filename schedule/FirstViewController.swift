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

// 頁面狀態
enum PageStatus {
    case LoadingMore
    case NotLoadingMore
}

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var localTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    let localPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    let sliderBarView = SliderBarView()
    var infoArr = [RLM_ApiData]()
    var pageStatus: PageStatus = .NotLoadingMore
    var arrayCount = 25
    var localArr = ["全部地點","台北","新北","桃園","新竹","苗栗","臺中","彰化","雲林","嘉義","台南","高雄","屏東","台東","花蓮","宜蘭","基隆","南投"]
    var typeArr = ["全部種類","貓","狗"]
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
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
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        self.resetInfoArr()
        self.updateTotal()
        
        sliderBarView.setUI(spView: self.view )
        
        
    }
    
    @objc func loadData(){
            self.resetInfoArr()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
    }
    
    
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoArr.count < 1{
            return 1
        }
        switch self.pageStatus {
        case .LoadingMore:
            if infoArr.count > arrayCount {
                return arrayCount + 1
            }else{
                return infoArr.count + 1
            }
        default:
            if infoArr.count > arrayCount {
                return arrayCount
            }else{
            return infoArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pageStatus == .LoadingMore && indexPath.row == arrayCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FirstTableViewCell
            if infoArr.count < 1{
               let noCell = UITableViewCell.init()
                noCell.textLabel?.text = "無資訊"
                return noCell
            }
            
            if cell == nil{
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") as! FirstTableViewCell
            }
            if indexPath.row < infoArr.count{
                let info = infoArr[indexPath.row]
                let cellImage = US.loadImage(fileName: "\(info.animal_id).jpg")
                cell.aniImage.image = cellImage?.scaleImage(scaleSize: 0.5)
                cell.type.text = "種類 : \(info.animal_kind)"
                cell.address.text = "位置 : \(info.shelter_name)"
                cell.checkDate.text = "登入日期 : \(info.cDate)"
                cell.likeBtn.tag = indexPath.row
                cell.likeBtn.addTarget(self, action: #selector(like(sender:)), for: .touchUpInside)
            }
            return cell
        }
        
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
            HUD.hide(afterDelay: 1.0) { (finish) in
                HUD.flash(.success, delay: 0.5)
            }
        idArr.append(info.animal_id)
        UD.set(idArr, forKey: "likeID")
        //NotificationCenter
        NotificationCenter.default.post(name: Notification.Name("loadData"), object: nil)
//        let alert = US.alertVC(message: "已加入收藏", title: "提醒")
//        self.present(alert,animated: true,completion: nil)
        }
    
    }
    
    @objc func search(){
        DispatchQueue.main.async {
            HUD.show(.label("稍等..."))
            //HUD.hide(afterDelay: 3.0)
            self.infoArr = []
            self.arrayCount = 25
            if let local = self.localTextField.text , let type = self.typeTextField.text {
                let realm = try! Realm()
                let orders = realm.objects(RLM_ApiData.self)
                if local == "全部地點" && type != "全部種類" {
                    for order in orders {
                        if order.animal_kind == type{
                            self.infoArr.append(order)
                        }
                    }
                }
                else if type == "全部種類" && local != "全部地點"  {
                    for order in orders {
                        if order.shelter_address.contains(local) {
                            self.infoArr.append(order)
                        }
                    }
                }
                else if local == "全部地點" && type == "全部種類"{
                    for order in orders {
                        self.infoArr.append(order)
                    }
                }
                else {
                    for order in orders {
                        if order.animal_kind == type && order.shelter_address.contains(local) {
                            self.infoArr.append(order)
                        }
                    }
                }
            }
            if self.infoArr.count > 0 && self.infoArr.count < 50 {
                for i in 0...self.infoArr.count - 1{
                    US.downloadImage(path: self.infoArr[i].album_file, name: self.infoArr[i].animal_id)
                }
            }
            if self.infoArr.count > 49{
                for i in 0...49{
                    US.downloadImage(path: self.infoArr[i].album_file, name: self.infoArr[i].animal_id)
                }
            }
            self.tableView.reloadData()
            let index = IndexPath.init(row: 0, section: 0)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            self.updateTotal()
            HUD.hide({ (finish) in
                HUD.flash(.success, delay:2)
            })
        }
        
    }
    
    //更新總共有幾筆資料
    func updateTotal(){
        self.navigationItem.title = "總共 : \(infoArr.count) 筆"
    }

     func resetInfoArr() {
        let realm = try! Realm()
        let orders = realm.objects(RLM_ApiData.self)
        if orders.count > 10{
            for order in orders{
                infoArr.append(order)
            }
        }
    }
    
    @IBAction func showSideBar(_ sender: Any) {
        sliderBarView.show()
    }
    
    

    
}




extension FirstViewController : UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > self.tableView.frame.height , self.pageStatus == .NotLoadingMore else{return}
        
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10{
            self.pageStatus = .LoadingMore
            self.tableView.reloadData {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.tableView.reloadData()
                    self.pageStatus = .NotLoadingMore
                    self.arrayCount += 25
                    //預載25張圖片
                    print(self.arrayCount)
                    for i in self.arrayCount...self.arrayCount + 25{
                        if self.infoArr.count > i {
                        US.downloadImage(path: self.infoArr[i-1].album_file, name: self.infoArr[i-1].animal_id)
                        }
                    }
                }
            }
        }
    }
}

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 1, animations: { self.reloadData() })
            { _ in completion() }
    }
}



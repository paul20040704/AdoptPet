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

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sterLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    let sliderBarView = SliderBarView()
    var infoArr = [RLM_ApiData]()
    var pageStatus: PageStatus = .NotLoadingMore
    var arrayCount = 25
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(search), name: NSNotification.Name(rawValue: "search"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        self.resetInfoArr()
        self.updateTotal()
        
        sliderBarView.setUI(spView: self.view )
        
        
    }
    
    @objc func loadData(){
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
    
    @IBAction func goSearch(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "First", bundle: .main)
        
        if #available(iOS 13.0, *) {
            let searchVC = storyBoard.instantiateViewController(identifier: "searchVC") 
            self.present(searchVC,animated:true,completion:nil)
        } else {
            let searchVC = storyBoard.instantiateViewController(withIdentifier: "searchVC")
            self.present(searchVC,animated: true,completion: nil)
        }
        
    }
    
    
    @objc func search(){
        changeLabel()
        DispatchQueue.main.async {
            HUD.show(.label("稍等..."))
            self.arrayCount = 25
            self.infoArr = US.search()
            self.tableView.reloadData()
            let index = IndexPath.init(row: 0, section: 0)
            //查詢完回頂部
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            self.updateTotal()
            //刪除所有條件
            sexArray.removeAll()
            typeArray.removeAll()
            sizeArray.removeAll()
            localArray.removeAll()
            ageArray.removeAll()
            sterilizationArray.removeAll()
            HUD.hide { (finish) in
                HUD.flash(.success,delay:2)
            }
        }
    }
    
    //更新總共有幾筆資料
    func updateTotal(){
        self.navigationItem.title = "總共 : \(infoArr.count) 筆"
    }

     func resetInfoArr() {
        infoArr = []
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
    
    @IBAction func resetCondition(_ sender: Any) {
        resetInfoArr()
        changeLabel()
        updateTotal()
        search()
        self.tableView.reloadData()
    }
    
    func changeLabel(){
        if typeArray.count == 2 || typeArray.count == 0{
            kindLabel.text = "全部種類"
        }
        if typeArray.count == 1{
            kindLabel.text = typeArray[0]
        }
        if localArray.count > 1 || localArray.count == 0{
            localLabel.text = "多個地區"
        }
        if localArray.count == 1{
            localLabel.text = localArray[0]
        }
        if sizeArray.count > 1 || sizeArray.count == 0{
            sizeLabel.text = "多種體型"
        }
        if sizeArray.count == 1{
            let size = sizeArray[0]
            switch size {
            case "SMALL":
                sizeLabel.text = "小型"
            case "MEDIUN":
                sizeLabel.text = "中型"
            case "BIG":
                sizeLabel.text = "大型"
            default:
                return
            }
        }
        if sexArray.count > 1 || localArray.count == 0{
            sexLabel.text = "不分性別"
        }
        if sexArray.count == 1{
            let sex = sexArray[0]
            switch sex {
            case "M":
                sexLabel.text = "公"
            default:
                sexLabel.text = "母"
            }
        }
        if sterilizationArray.count > 1 || sterilizationArray.count == 0{
            sterLabel.text = "絕育未定"
        }
        if sterilizationArray.count == 1{
            let sterilization = sterilizationArray[0]
            switch sterilization {
            case "T":
                sterLabel.text = "是"
            case "F":
                sterLabel.text = "否"
            default:
                sterLabel.text = "未知"
            }
        }
        if ageArray.count > 1 || ageArray.count == 0{
            ageLabel.text = "不分年紀"
        }
        if ageArray.count == 1{
            let age = ageArray[0]
            switch age {
            case "ADULT":
                ageLabel.text = "成年"
            default:
                ageLabel.text = "幼年"
            }
        }
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



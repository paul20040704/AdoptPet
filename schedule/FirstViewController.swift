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
import Reachability

// 頁面狀態
enum PageStatus {
    case LoadingMore
    case NotLoadingMore
}

var sliderBarSelect = false

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ReloadDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sliderBarView = SliderBarView()
    var infoArr = [RLM_ApiData]()
    var pageStatus: PageStatus = .NotLoadingMore
    var arrayCount = 25
    var refreshControl : UIRefreshControl!
    var reachability = try! Reachability()
    var conditionArr = Array<String>()
    let hangBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reachability!.whenReachable = { reachability in
            self.netLabel.isHidden = true
        }
        
        self.reachability?.whenUnreachable = { reachability in
            self.netLabel.isHidden = false
        }
        
        do {
            try self.reachability!.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(search), name: NSNotification.Name(rawValue: "search"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        self.resetInfoArr()
        self.updateTotal()
        
        sliderBarView.setUI(spView: self.view)
        
//        let sb = UIStoryboard.init(name: "Second", bundle: Bundle.main)
//        let secondVC = sb.instantiateViewController(withIdentifier: "Second") as! SecondViewController
        let navVC = (self.tabBarController?.viewControllers![1])! as! UINavigationController
        let secondVC = navVC.viewControllers.first as! SecondViewController

        
        secondVC.RDelegate = self
        
        self.perform(#selector(createButton), with: nil, afterDelay: 1)
        
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hangBtn.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hangBtn.isHidden = true
    }
    
    @objc func createButton() {
        hangBtn.setTitle("回頂", for: .normal)
        hangBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        hangBtn.layer.cornerRadius = 20
        hangBtn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        hangBtn.frame = CGRect(x: screenWidth - 50 , y: screenHeight - 150, width: 40, height: 40)
        hangBtn.addTarget(self, action: #selector(goTop), for: .touchUpInside)
        //let window = UIWindow.init(frame: CGRect(x: 100, y: 200, width: 80, height: 80))
        self.view.window?.addSubview(hangBtn)
        self.view.window?.makeKeyAndVisible()
        
    }
    
    @objc func goTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0 - self.tableView.contentInset.top), animated: false)
    }
    
    @objc func loadData(){
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
    }
    
    //Delegale
    func reloadData() {
        self.tableView.reloadData()
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
                noCell.selectionStyle = .none
                noCell.backgroundColor = defultColor
                tableView.backgroundColor = defultColor
                return noCell
            }
            
            if cell == nil{
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") as! FirstTableViewCell
            }
            if indexPath.row < infoArr.count{
                let info = infoArr[indexPath.row]
                if US.judgeImage(fileName: "\(info.animal_id).jpg"){
                    let cellImage = US.loadImage(fileName: "\(info.animal_id).jpg")
                    cell.aniImage.image = cellImage?.scaleImage(scaleSize: 0.5)
                }else{
                    downloadForCell(path: "\(info.album_file)", name: "\(info.animal_id)")
                    cell.aniImage.image = UIImage.gif(name: "loadView")
                }
                cell.type.text = "種類 : \(info.animal_kind)"
                cell.address.text = "位置 : \(info.shelter_name)"
                cell.checkDate.text = "登入日期 : \(info.cDate)"
                if isAddLike(id: info.animal_id){
                    cell.likeBtn.setImage(UIImage(named: "rHeart"), for: .normal)
                }else{
                    cell.likeBtn.setImage(UIImage(named: "wHeart"), for: .normal)
                }
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
        print(info.animal_id)
        navigationController?.show(firstDetailVC, sender: nil)
      }
    }
    
    //UICollectionDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if conditionArr.count < 1{
            return 1
        }else{
            return conditionArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConditionCollectionViewCell
        if conditionArr.count < 1{
            cell.conditionLabel.text = "全部條件"
        }else{
            cell.conditionLabel.text = conditionArr[indexPath.row]
        }
        return cell
    }
    
    
    //按下喜歡
    @objc func like (sender:UIButton){
        let info = infoArr[sender.tag]
        var idArr = [String]()
        if let id = UD.array(forKey: "likeID") {
            idArr = id as! [String]
        }
        HUD.show(.label("更新中..."))
            HUD.hide(afterDelay: 0.3) { (finish) in
                HUD.flash(.success, delay: 0.3)
            }
        if idArr.contains(info.animal_id){
            self.tableView.reloadData()
            var i = 0
            for id in idArr{
                if id == info.animal_id {
                    idArr.remove(at: i)
                    UD.set(idArr, forKey: "likeID")
                    self.tableView.reloadData()
                    NotificationCenter.default.post(name: Notification.Name("loadData"), object: nil)
                }
                i += 1
            }
        }else{
            idArr.append(info.animal_id)
            UD.set(idArr, forKey: "likeID")
            self.tableView.reloadData()
            //NotificationCenter
            NotificationCenter.default.post(name: Notification.Name("loadData"), object: nil)
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
        //changeLabel()
        conditionArr = US.showConditionArr()
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            HUD.show(.label("稍等..."))
            self.arrayCount = 25
            //篩選條件方法
            self.infoArr = US.search()
            for i in 0...self.infoArr.count - 1{
                if i < 50{
                    if !(US.judgeImage(fileName: "\(self.infoArr[i].animal_id).jpg")){
                        US.downloadImage(path: self.infoArr[i].album_file, name: self.infoArr[i].animal_id)
                    }
                }
            }
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
            timeGapArray.removeAll()
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
        let orders = realm.objects(RLM_ApiData.self).sorted(byKeyPath: "animal_createtime", ascending: false)
        if orders.count > 10{
            for order in orders{
                infoArr.append(order)
            }
        }
    }
    
    @IBAction func showSideBar(_ sender: Any) {
        if sliderBarSelect {
            sliderBarView.hide()
            sliderBarSelect = false
        }else{
            sliderBarView.show()
            sliderBarSelect = true
        }
    
    }
    
    @IBAction func hint(_ sender: Any) {
       let alert =  US.alertVC(message: "  你可以在這邊找到目前台灣各收容所，等待領養的貓狗們，並且加入他們到最愛。", title: "提示")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func resetCondition(_ sender: Any) {
        resetInfoArr()
        //changeLabel()
        conditionArr = US.showConditionArr()
        self.collectionView.reloadData()
        updateTotal()
        search()
        self.tableView.reloadData()
    }
    
    
   //下載cell需要的圖片並更新cell
    func downloadForCell(path:String ,name:String) {
        DispatchQueue.global().async {
            let fileName = "\(name).jpg"
            let filePath = US.fileDocumentsPath(fileName: fileName)
            if let imgUrl = URL(string: path){
                do{
                    let imgData = try Data(contentsOf: imgUrl)
                    try imgData.write(to: filePath)
                }catch{
                    print("\(name) : catch imageData fail..")
                }
            }else{
                print("\(name) : analysis imageUrl fail..")
            }
        }
    }
    
    //判斷是否已經加入收藏
    func isAddLike(id:String) -> Bool {
        var idArr = [""]
        if let arr = UD.array(forKey: "likeID") as? [String] {
            idArr = arr
        }
        if idArr.contains(id) {
            return true
        }else{
            return false
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
                    print("arrayCount\(self.arrayCount)")
                    for i in self.arrayCount...self.arrayCount + 25{
                        if self.infoArr.count > i {
                            if !(US.judgeImage(fileName: "\(self.infoArr[i-1].animal_id).jpg")){
                                US.downloadImage(path: self.infoArr[i-1].album_file, name: self.infoArr[i-1].animal_id)
                            }
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



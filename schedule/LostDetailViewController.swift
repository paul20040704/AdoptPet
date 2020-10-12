//
//  LostDetailViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
import Reachability

class LostDetailViewController: UIViewController ,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    
    var reachability = try! Reachability()
    var info = [String:Any]()
    var key = String()
    //0:加入關注 1:取消關注
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "遺失待領回"
        
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
        
        scrollView.delegate = self
        guard let urlArray = info["photoArray"] as? Array<String> else{return}
        let urlCount = urlArray.count
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(urlCount) , height: scrollView.frame.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        // Do any additional setup after loading the view.
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = urlCount
        pageControl.currentPage = 0
        
        kindLabel.text = "種類 : \(info["kind"] as! String)"
        dateLabel.text = "拾獲日期 : \(info["pickDate"] as! String)"
        placeLabel.text = "拾獲地 : \(info["place"] as! String)"
        contactLabel.text = "聯絡方式 : \(info["contact"] as! String)"
        remarkLabel.text = "特徵 : \(info["remark"] as! String)"
        
        if type == 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "加入關注", style: .plain, target: self, action: #selector(addFollow))
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消關注", style: .plain, target: self, action: #selector(cancelFollow))
        }
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        
        setupImageView()
        
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    func setupImageView() {
        guard let urlArray = info["photoArray"] as? Array<String> else{return}
        for i in 0...(urlArray.count - 1){
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width , height:scrollView.frame.height - 30))
            if let imageUrl = URL(string: urlArray[i]) {
                let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    if let data = data , let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
                task.resume()
            }
            scrollView.addSubview(imageView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    @objc func addFollow() {
        if var followArray = UD.array(forKey: "LostKey") as? [String] {
            if followArray.contains(key){
                CTAlertView.ctalertView.showAlert(title: "提醒", body: "已加入收藏", action: "確定")
            }else{
                HUD.show(.label("加入關注..."))
                followArray.append(key)
                UD.set(followArray, forKey: "LostKey")
                HUD.flash(.success, delay: 0.5)
            }
        }else{
            HUD.show(.label("加入關注..."))
            var keyArr = [key]
            UD.set(keyArr, forKey: "LostKey")
            HUD.flash(.success, delay: 0.5)
        }
    }
    
    @objc func cancelFollow(){
        if var followArray = UD.array(forKey: "LostKey") as? [String] {
            if !followArray.contains(key){
                CTAlertView.ctalertView.showAlert(title: "提醒", body: "已加入收藏", action: "確定")
            }else {
                HUD.show(.label("取消關注..."))
                var i = 0
                for udKey in followArray {
                    if udKey == key {
                        followArray.remove(at: i)
                        UD.set(followArray, forKey: "LostKey")
                    }
                    i += 1
                }
                HUD.flash(.success, delay: 0.5)
            }
        }
    }
    

    

}

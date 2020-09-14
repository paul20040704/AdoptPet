//
//  LostDetailViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/9/11.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import UIKit
import SDWebImage

class LostDetailViewController: UIViewController ,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    var info = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "遺失待領回"
        
        scrollView.delegate = self
        guard let urlArray = info["photoArray"] as? Array<String> else{return}
        let urlCount = urlArray.count
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(urlCount) , height: scrollView.frame.height)
        scrollView.bounces = true
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
        
        setupImageView()
        
    }
    
    func setupImageView() {
        guard let urlArray = info["photoArray"] as? Array<String> else{return}
        for i in 0...(urlArray.count - 1){
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height:scrollView.frame.height - 50))
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
    
    

    

}

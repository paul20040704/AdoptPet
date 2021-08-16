//
//  ScrollImageVC.swift
//  schedule
//
//  Created by paul on 2021/8/9.
//  Copyright © 2021 TimeCity. All rights reserved.
//

import UIKit
import SDWebImage

class ScrollImageVC: UIViewController {
    
    static let scrollImageVC = ScrollImageVC()
    
    var scrollView = UIScrollView()
    var scrollImage = UIImageView()
    var cachedImage = UIImage()
    var url : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.view.backgroundColor = .darkGray
        
        scrollImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))
        scrollImage.image = cachedImage
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = scrollImage.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        scrollView.addSubview(scrollImage)
        self.view.addSubview(scrollView)
        
        scrollView.delegate = self
        updateZoomSizeFor(size: self.view.bounds.size)
        setTap()
    }

    func updateZoomSizeFor(size: CGSize){
        let widthScale = size.width / scrollImage.bounds.width
        let heightScale = size.height / scrollImage.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
    }
    
    func setTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hide))
        let swipeDown = UISwipeGestureRecognizer.init(target: self, action: #selector(hide))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func hide(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension ScrollImageVC : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        scrollImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let inset = (scrollView.bounds.height - scrollImage.frame.height) / 2
        scrollView.contentInset = .init(top: max(inset, 0), left: 0, bottom: 0, right: 0)
    }
}

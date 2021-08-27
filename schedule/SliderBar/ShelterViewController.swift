//
//  ShelterViewController.swift
//  schedule
//
//  Created by paul on 2021/8/24.
//  Copyright © 2021 TimeCity. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class ShelterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let mapView = MKMapView()
    //當前地圖的地址
    var address = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        //ios13以上全螢幕
        if #available(iOS 13.0, *) {
            self.modalPresentationStyle = .fullScreen
        }
        
        tableView.register(UINib(nibName:"ShelterCell", bundle: nil), forCellReuseIdentifier: "ShelterCell")
        setTableView()
        setMapView()
        mapViewAddress(mark: "新北市政府動物保護防疫處")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .denied{
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController,animated:true,completion:nil)
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shelterData[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShelterCell = tableView.dequeueReusableCell(withIdentifier: "ShelterCell") as! ShelterCell
        cell.label.text = shelterData[indexPath.section].1[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shelterData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray
        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: screenWidth, height: 50))
        viewLabel.text = shelterData[section].0
        viewLabel.textColor = .white
        viewLabel.font = UIFont.init(name:"GillSans", size: 20)
        view.addSubview(viewLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mark = shelterData[indexPath.section].1[indexPath.row]
        mapViewAddress(mark: mark)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func setTableView(){
        BackBtnView.backBtnView.setBtn(superVC: self)
        self.view.backgroundColor = .gray
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight * 0.45)
            make.top.equalTo(self.view).offset(80)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
    }
    
    func setMapView(){
        self.view.addSubview(mapView)
        mapView.mapType = .standard
        mapView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight * 0.4)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(goMap))
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(tap)
    }

    func mapViewAddress(mark: String){
        let annotation = mapView.annotations
        if annotation.count > 0 {
            self.mapView.removeAnnotation(annotation[0])
        }
        address = shelterAddressDic[mark]!
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks:[Any]!, error:Error!) in
            if error != nil{
                print(error as Any)
                return
            }
            if placemarks != nil && placemarks.count > 0 {
                let targetPlacemark = placemarks[0] as! CLPlacemark
                guard let latitude = targetPlacemark.location?.coordinate.latitude ,let longitude = targetPlacemark.location?.coordinate.longitude else {return}
                self.mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 500,longitudinalMeters: 500)
                //加入地圖標記
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = mark
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    @objc func goMap(){
        let sb = UIStoryboard.init(name: "First", bundle: nil)
        let GoogleMapVC = sb.instantiateViewController(withIdentifier: "GoogleMapVC") as! GoogleMapViewController
        GoogleMapVC.pickAddress = address
        self.present(GoogleMapVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    

}

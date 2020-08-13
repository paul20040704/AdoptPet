//
//  GoogleMapViewController.swift
//  schedule
//
//  Created by 陳彥甫 on 2020/3/18.
//  Copyright © 2020 TimeCity. All rights reserved.
//

import GoogleMaps
import UIKit
import MapKit
import CoreLocation

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var googleMapView: MKMapView!
    
    
    let myLocationManager = CLLocationManager()
    var pickAddress : String = ""
    var userPlacemark : CLPlacemark? = nil
    var targetPlacemark : CLPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager.delegate = self
        //user授權
        myLocationManager.requestWhenInUseAuthorization()
        //開始更新user位置
        myLocationManager.startUpdatingLocation()
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        //設定為最佳精度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.transformAddress(address:pickAddress)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .notDetermined{
            myLocationManager.requestWhenInUseAuthorization()
            myLocationManager.startUpdatingHeading()
        }
        else if CLLocationManager.authorizationStatus() == .denied{
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController,animated:true,completion:nil)
            }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                myLocationManager.startUpdatingHeading()
            }
        }
    
    func transformAddress(address:String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks:[Any]!, error:Error!) in
            if error != nil{
                print(error)
                return
            }
            if placemarks != nil && placemarks.count > 0{
                self.targetPlacemark = placemarks[0] as! CLPlacemark
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: (self.targetPlacemark?.location?.coordinate.latitude)!, longitude: (self.targetPlacemark?.location?.coordinate.longitude)!)
                self.googleMapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0]
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks:[Any]!, error:Error!) in
            if error != nil{
               print(error)
               return
            }
            if placemarks != nil && placemarks.count > 0{
                self.userPlacemark = placemarks[0] as! CLPlacemark
            }
        }
        
    }
    
    @IBAction func mapNavagation(_ sender: Any) {
        if let user = userPlacemark , let target = targetPlacemark{
            let startMK : MKPlacemark = MKPlacemark(placemark: user)
            let startItem : MKMapItem = MKMapItem(placemark: startMK)
            
            let endMK : MKPlacemark = MKPlacemark(placemark: target)
            let endItem : MKMapItem = MKMapItem(placemark: endMK)
            
            let mapItems : [MKMapItem] = [startItem,endItem]
            
            let dic : [String:Any] = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving as Any, MKLaunchOptionsMapTypeKey : MKMapType.standard.rawValue as Any,
                MKLaunchOptionsShowsTrafficKey : true as Any]
            
            MKMapItem.openMaps(with: mapItems, launchOptions: dic)
        }
    }
    
    
    
    

    
}




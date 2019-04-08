//
//  MapController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 11/27/18.
//  Copyright © 2018 Erandra Jayasundara. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import SVProgressHUD
import JSSAlertView
import CoreMotion
import CommonCrypto

class MapController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    var locations = [MissionLocation]()
    var mapView=GMSMapView()
    let altimeter = CMAltimeter()
    let manager=CLLocationManager()
    var firstTime = true
    let doMissionView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    let closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeDoMission), for: .touchUpInside)
        return btn
    }()
    let airPressureLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r:77,g:175,b:81)
        label.text = "AIR PRESSURE"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let altitudeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r:77,g:175,b:81)
        label.text = "ALTITUDE"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let airPressureTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder="Air Pressure"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let altitudeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder="Altitude"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let getAirPressureButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Get Sensor Values", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(airPressure), for: .touchUpInside)
        return button
    }()
    let updateDetailsButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Update", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(updateDBWithSensorValue), for: .touchUpInside)
        return button
    }()
    @objc func closeDoMission(){
        doMissionView.removeFromSuperview()
    }
    @objc func updateDBWithSensorValue(){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let values = ["altitude":self.altitudeTextField.text,
                      "pressure":self.airPressureTextField.text]
        ref.child("details").child("air").child(MD5(mission_code)!).setValue(values){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                SVProgressHUD.dismiss()
            } else {
                print("Data saved successfully!")
                let nref = Database.database().reference()
                nref.child("score").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        print("inside")
                        let score = Int(dictionary[uid!] as! String)!+5
                        nref.child("score").child(uid!).setValue("\(score)")
                        SVProgressHUD.dismiss()
                    }
                }, withCancel:  nil)
                self.doMissionView.removeFromSuperview()
            }
        }
        
    }
    override func loadView() {
        let camera=GMSCameraPosition.camera(withLatitude:6.925917 , longitude:79.866579 , zoom: 14.0)
        mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.isMyLocationEnabled=true
        mapView.settings.myLocationButton = true
        view=mapView
        
    }
    @objc func airPressure(){
        if firstTime{
            if CMAltimeter.isRelativeAltitudeAvailable() {
                // 2
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                    // 3
                    if (error == nil) {
                        self.airPressureTextField.text = data?.pressure.stringValue
                        self.altitudeTextField.text = data?.relativeAltitude.stringValue
                    }
                })
            }else{
                print("not avalable")
            }
            getAirPressureButton.backgroundColor = .red
            getAirPressureButton.setTitle("Stop Sensor Values", for: .normal)
            firstTime = false
        }else{
            getAirPressureButton.backgroundColor=UIColor(r:77,g:175,b:81)
            getAirPressureButton.setTitle("Get Sensor Values", for: .normal)
            altimeter.stopRelativeAltitudeUpdates()
            firstTime = true
        }
    }
    var mission_code = ""
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let location = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        let location2 = CLLocation(latitude: (mapView.myLocation?.coordinate.latitude)!, longitude:  (mapView.myLocation?.coordinate.longitude)!)
        mission_code.append(String(marker.position.latitude))
        mission_code.append(String(marker.position.longitude))
        let distance = location.distance(from: location2)
        let customIcon = UIImage(named: "testlg")
        let customColor = UIColor(r:77,g:175,b:81)
       
        
        view.addSubview(doMissionView)
        doMissionView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        doMissionView.addSubview(closeButton)
        closeButton.setAnchor(top: doMissionView.topAnchor, left: nil, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 20,height: 20)
        doMissionView.addSubview(airPressureLabel)
        airPressureLabel.setAnchor(top: closeButton.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        doMissionView.addSubview(airPressureTextField)
        airPressureTextField.setAnchor(top: airPressureLabel.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10,width: 0,height: 40)
        doMissionView.addSubview(altitudeLabel)
        altitudeLabel.setAnchor(top: airPressureTextField.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        doMissionView.addSubview(altitudeTextField)
        altitudeTextField.setAnchor(top: altitudeLabel.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        doMissionView.addSubview(getAirPressureButton)
        getAirPressureButton.setAnchor(top: altitudeTextField.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        doMissionView.addSubview(updateDetailsButton)
        updateDetailsButton.setAnchor(top: getAirPressureButton.bottomAnchor, left: doMissionView.leftAnchor, bottom: nil, right: doMissionView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        if(distance<100){
            print("you can play")
        }else{
            JSSAlertView().show(
                self,
                title: "You Cannot Play",
                text: "You are far from the location.",
                buttonText: "OK",
                color: customColor,
                iconImage: customIcon).setTextTheme(.light)
            doMissionView.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        loadMissions()
       
    }
    
    var load = false{
        didSet{
            if load == true{
                
            for mission in locations {
                let mission_marker = GMSMarker()
                mission_marker.position = CLLocationCoordinate2D(latitude: mission.lat!, longitude: mission.long!)
                mission_marker.title = mission.name
                if mission.complete!{
                    mission_marker.icon = UIImage(named: "markercomplete")
                }else{
                    mission_marker.icon = UIImage(named: "marker")
                }
                
                mission_marker.snippet = mission.desc
                mission_marker.map = mapView
            }
        }
        }
    }
    func loadMissions(){
        SVProgressHUD.setForegroundColor(UIColor(r:77,g:175,b:81))
        SVProgressHUD.show()
        Database.database().reference().child("events").observe(.childAdded, with: { (snapshot) in
            if let array:NSArray = snapshot.children.allObjects as NSArray{
                for child in array{
                    let snap = child as! DataSnapshot
                    if let dictionary = snap.value as? [String:AnyObject]{
                        let location = MissionLocation()
                        location.name = dictionary["name"] as? String
                        location.lat = Double(dictionary["latitude"] as! String)
                        location.long = Double(dictionary["longitude"] as! String)
                        location.desc = dictionary["description"] as? String
                        var mission_code_check = ""
                        mission_code_check.append(dictionary["latitude"] as! String)
                        mission_code_check.append(dictionary["longitude"] as! String)
                        Database.database().reference().child("details").child("air").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if snapshot.hasChild(self.MD5(mission_code_check)!){
                                
                                print("true rooms exist")
                                location.complete = true
                                self.locations.append(location)
                                self.load = true
                            }else{
                                location.complete = false
                                print("false room doesn't exist")
                                self.locations.append(location)
                                self.load = true
                            }
                            
                            
                        })
                     
                    }
                }
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
            }
        }, withCancel: nil)
        
        
    }

 
   
    
    var first:Bool=true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[0]
        
        let camera=GMSCameraPosition.camera(withLatitude:location.coordinate.latitude , longitude: location.coordinate.longitude, zoom: 14.0)
        if first{
            mapView.camera=camera
            first=false
        }
        
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        mapView.clear()
        loadMissions()
    }
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }

   

}
class MissionLocation {
    var name: String?
    var desc: String?
    var long: CLLocationDegrees?
    var lat: CLLocationDegrees?
    var complete: Bool?
}

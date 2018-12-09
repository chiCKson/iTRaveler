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
class MapController: UIViewController,CLLocationManagerDelegate {
    
    var mapView=GMSMapView()
    let manager=CLLocationManager()
    override func loadView() {
        let camera=GMSCameraPosition.camera(withLatitude:6.925917 , longitude:79.866579 , zoom: 14.0)
        mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
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
        view=mapView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
       
    }

 
  
    
    var first:Bool=true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[0]
        
        let camera=GMSCameraPosition.camera(withLatitude:location.coordinate.latitude , longitude: location.coordinate.longitude, zoom: 14.0)
        if first{
            mapView.camera=camera
            first=false
        }
        
        mapView.clear()
        let marker=GMSMarker()
        
        marker.position=CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title="I'm Here"
       // marker.map=mapView
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

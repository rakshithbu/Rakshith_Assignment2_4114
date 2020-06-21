//
//  MapViewController.swift
//  MapFavourates
//
//  Created by Rakshith on 21/06/20.
//  Copyright © 2020 Rakshith. All rights reserved.
//

import UIKit
import MapKit

import GLKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var selectedLocation: CLLocationCoordinate2D? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        map.addGestureRecognizer(longPressRecogniser)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
        @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
            if gestureRecognizer.state != .began { return }
            
                let touchPoint = gestureRecognizer.location(in: map)
                let touchMapCoordinate = map.convert(touchPoint, toCoordinateFrom: map)
                selectedLocation = touchMapCoordinate
                let myPin: MKPointAnnotation = MKPointAnnotation()
                myPin.coordinate = touchMapCoordinate
            let latitude = selectedLocation?.latitude
            let longitude = selectedLocation?.longitude
            
            
           
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude! , longitude:longitude!  )) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {

                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    var adressString : String = ""
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                 if place.country != nil {
                     adressString = adressString + place.country!
                 }
                 print("addresssss")
                 print(adressString)
                   myPin.title = adressString
                     myPin.title = adressString
                 
             }
             }
             }
               
                map.addAnnotation(myPin)
                
                
                
                let facourate = Favourates(context: PersistanceService.context)
                facourate.id = UUID().uuidString
            facourate.location = "\(String(format: "%f", selectedLocation?.latitude as! CVarArg)) \(String(format: "%f", selectedLocation?.longitude as! CVarArg))"

            PersistanceService.saveContext()

            let notificationPayload = ["coordinate": facourate]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAdded"), object: self, userInfo: notificationPayload)

            
            
        }


}

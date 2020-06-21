//
//  MapDetailViewController.swift
//  MapFavourates
//
//  Created by Rakshith on 21/06/20.
//  Copyright © 2020 Rakshith. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {

    @IBOutlet weak var mapDetailView: MKMapView!
    var locationString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        // Do any additional setup after loading the view.
    }
    
    func setupMap(){
        let array = locationString.components(separatedBy: " ")

        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((array[0] as NSString).doubleValue), longitude: Double((array[1] as NSString).doubleValue))

       let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = location
        print(array[0], array[1])
        
       CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: Double((array[0] as NSString).doubleValue), longitude: Double((array[1] as NSString).doubleValue))) { (placemark, error) in
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
            
        }
        }
        }
      
        mapDetailView.addAnnotation(myPin)
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

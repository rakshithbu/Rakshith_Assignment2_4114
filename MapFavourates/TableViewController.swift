//
//  TableViewController.swift
//  MapFavourates
//
//  Created by Rakshith on 21/06/20.
//  Copyright © 2020 Rakshith. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TableViewController: UITableViewController {

    var currentFavouratesDataSource = [Favourates]()
    var selectedDetailLocationString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: "locationAdded"), object: nil)
        
        let favouratesFetchRequest: NSFetchRequest<Favourates> = Favourates.fetchRequest()
                       do{
                           self.currentFavouratesDataSource = try PersistanceService.context.fetch(favouratesFetchRequest)
                        print(currentFavouratesDataSource.count)
                           self.tableView.reloadData()
                       } catch{
                           
                       }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentFavouratesDataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavourateCell
     
        print("inside table")
        let location = currentFavouratesDataSource[indexPath.row].location!;
      
       let locationArray = location.split(separator: " ")
        
        print(locationArray[0])
         print(locationArray[1])
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: Double((locationArray[0] as NSString).doubleValue), longitude: Double((locationArray[1] as NSString).doubleValue))) { (placemark, error) in
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
                 cell.title.text = adressString
             
         }
         }
         }
        cell.coordinate.text = currentFavouratesDataSource[indexPath.row].location
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDetailLocationString = currentFavouratesDataSource[indexPath.row].location!
        //
        self.performSegue(withIdentifier: "mapDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavourateHandler(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    @objc func reloadTableView(_ notification: Notification){
        let data = notification.userInfo as? [String: Favourates]
        
        for (_, location) in data!
        {
            currentFavouratesDataSource.append(location)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "mapDetailSegue"
        {
            let destination = segue.destination as? MapDetailViewController
            destination?.locationString = self.selectedDetailLocationString
        }
    }
    func deleteFavourateHandler(indexPath: IndexPath){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourates")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentFavouratesDataSource[indexPath.row].id!)

        do{
        let fetchResults = try PersistanceService.context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                let managedObject: Favourates = fetchResults[0] as! Favourates
                PersistanceService.context.delete(managedObject)
                    
                do {
                    try PersistanceService.context.save()
                }
                catch {
                        
                }
                currentFavouratesDataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
            
        } catch{
            
        }
    }

}

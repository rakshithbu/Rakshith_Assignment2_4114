//
//  Favourates+CoreDataProperties.swift
//  MapFavourates
//
//  Created by Rakshith on 21/06/20.
//  Copyright © 2020 Rakshith. All rights reserved.
//
//

import Foundation
import CoreData


extension Favourates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourates> {
        return NSFetchRequest<Favourates>(entityName: "Favourates")
    }

    @NSManaged public var id: String?
    @NSManaged public var location: String?

}

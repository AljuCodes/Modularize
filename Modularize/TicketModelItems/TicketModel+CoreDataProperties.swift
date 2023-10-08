//
//  TicketModel+CoreDataProperties.swift
//  Modularize
//
//  Created by FAO on 06/10/23.
//
//

import Foundation
import CoreData


extension TicketModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketModel> {
        return NSFetchRequest<TicketModel>(entityName: "TicketModel")
    }

    @NSManaged public var title: String
    @NSManaged public var isDone: Bool
    @NSManaged public var id: UUID
    @NSManaged public var superId: UUID?
    
    // Add a custom initializer
    convenience init(title: String, isDone: Bool, id: UUID, superId: UUID?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.isDone = isDone
        self.id = id
        self.superId = superId
    }

}

extension TicketModel : Identifiable {

}

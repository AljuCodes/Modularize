//
//  TicketListVIewVM.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import Foundation
import UIKit
import CoreData


final class TicketListViewVM {
    
    private var tickets: [TicketModel] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        self.getAllTickets()
    }
    func getAllTickets() {
            let fetchRequest: NSFetchRequest<TicketModel> = TicketModel.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "superId == nil")

            do {
                let fetchedTickets = try context.fetch(fetchRequest)
                self.tickets = fetchedTickets
            } catch let error as NSError {
                print("Could not fetch tickets. \(error), \(error.userInfo)")
            }
        }
    
    private func saveContext(){
        do {
           try context.save()
        } catch {
            fatalError("fatal error")
        }
    }
    
    public func appendTicket(title: String, superId: UUID?)  {
        let tm = TicketModel(
            title: title,
            isDone: false,
            id: UUID(),
            superId: superId,
            context: context
        )
        tickets.append(tm)
        saveContext()
     }
    
    public func findTicketIndexWithId(_ id: UUID) -> Int {
       let tm =  tickets.firstIndex{ tm in
            tm.id == id
        }
        guard let tm = tm else {
            fatalError("look for shit")
        }
        return tm
    }
    
    public func toggleTicketIsDone(id : UUID) {
        let index = findTicketIndexWithId(id)
        let item = tickets[index]
        tickets[index].isDone.toggle()
        // TODO: check if this is necesary
        item.isDone.toggle()
        saveContext()
    }
    
    
    public func renameTicketTitle(id : UUID, title: String) {
        let index = findTicketIndexWithId(id)
        let item = tickets[index]
        tickets[index].title = title
        // TODO: check if this is necesary
        item.title = title
        saveContext()
    }
    
    
    public func getSubTickets(_ id : UUID) -> [TicketModel] {
        
        let subTickets = tickets.filter { tm in
            tm.superId == id
        }
        return subTickets
    }
        
        public func getSubTicketCount(_ id: UUID) -> Int {
            let subTickets = getSubTickets(id)
            return subTickets.count
    }
    
    public func deleteTicket(_ id : UUID)  {
        let index = findTicketIndexWithId(id)
        let item = tickets[index]
        
        let subTickets = getSubTickets(id)
        if(subTickets.isEmpty){
            tickets.removeAll{ tm in
                if(tm.id == id){
                    print("deleted ticket title is \(tm.title)")
                }
                return tm.id == id
            }
            context.delete(item)
            saveContext()
        } else {
            subTickets.forEach{ ST in
                deleteTicket(ST.id) // remove subticket's subtickets
            }
            deleteTicket(id)
        }
        printTickets()
    }
    
    public func printTickets(){
        print("**********")
        tickets.forEach{ tm in
            print(tm.title)
        }
        print("##########")
    }
    
    public func getSuperTickets() -> [TicketModel] {
        return tickets.filter{ tm in
            tm.superId == nil
        }
    }
        
    public func getTicket(_ id: UUID) -> TicketModel {
        let index = findTicketIndexWithId(id)
        let item = tickets[index]
        return item
    }
    
    public var superTicketCount: Int {
        return getSuperTickets().count
    }
    
    public func getProgress(_ id : UUID) -> String {
        let subTickets = getSubTickets(id)
        let completedTickets = subTickets.filter{ tm in
            tm.isDone == true
        }
        if(subTickets.isEmpty || completedTickets.count == 0){
            return "0"
        }
        let value =  (Float(completedTickets.count) / Float(subTickets.count))
        print(value)
        return String(describing: value * 100)
    }
}

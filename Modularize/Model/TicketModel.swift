//
//  TicketModel.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import Foundation


final class TicketModel : Identifiable, Codable {
    public let  id: UUID
    var title: String
    
    public func setTitle(title:String){
        self.title = title
    }
    
    
    private var tickets: [UUID] = []
    
    public func getTickets() -> [UUID] {
        return tickets
    }
    
    public func ticketCount() -> Int {
        return tickets.count
    }
    
   public func appendTicket(with ticket: UUID)  {
        self.tickets.append(ticket)
    }
    
    public func toggleIsDone(){
        isDone = !isDone
    }
    
    public func removeTicket(with id : UUID){
        self.tickets.removeAll { ticketId in
            ticketId == id
        }
    }
    
    public private(set) var isDone: Bool
    
    
    public func progress(vm: TicketListViewVM)-> String {
        if(tickets.count == 0){
            return "0"
        }
        let finishedTickets = tickets.compactMap({
             return vm.getTicket(with: $0)
        }).filter{
            t in
            t.isDone == true
        }
        
        let result = (Float(finishedTickets.count) / Float(tickets.count))
        let value  = Int( result * 100)
        
        return String(describing: value)
    }
    
    init(title: String, tickets: [UUID] = [], isDone: Bool, id: UUID = UUID())  {
        self.title = title
        self.tickets = tickets
        self.isDone = isDone
        self.id = id
    }
}




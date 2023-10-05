//
//  TicketListVIewVM.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import Foundation


final class TicketListViewVM {
    
   static let dummySubTickets = [
        TicketModel(
            title: "Complete cooking with everything you ever wanted you knwo about the all blue, where all the sea comes together",
            isDone: false
        ),
        TicketModel(
            title: "Complete cooking",
            isDone: true
        ),
            TicketModel(
                title: "Complete cooking with everything you ever wanted you knwo about the all blue, where all the sea comes together",
                isDone: false
            ),
            TicketModel(
                title: "Complete cooking",
                isDone: true
            ),
        
        TicketModel(
            title: "Complete cooking with everything you ever wanted you knwo about the all blue, where all the sea comes together",
            isDone: true
        ),
        TicketModel(
            title: "Complete cooking with everything you ever wanted you knwo about the all blue, where all the sea comes together",
            isDone: false
        ),
       ]
    
    private let firstKey : UUID
    private let secondKey : UUID
    
    private var ticketDictionary: [UUID : [TicketModel]] = [:]
    
    init(firstKey: UUID? = nil, secondKey: UUID? = nil) {
        self.firstKey = firstKey ?? UUID()
        self.secondKey = secondKey ?? UUID()
        let dummyTicketIds = TicketListViewVM.dummySubTickets.compactMap({
            return $0.id
        })
        self.ticketDictionary[self.firstKey] = [
            TicketModel(
            title: "Complete youtube tutorial",
            tickets: dummyTicketIds,
            isDone: true
        ),
            TicketModel(
            title: "Complete youtube tutorial 2",
            tickets: dummyTicketIds,
            isDone: true
        ),
            TicketModel(
            title: "Complete youtube tutorial 3",
            isDone: true
        ),
            TicketModel(
            title: "Complete youtube tutorial 4",
            tickets: dummyTicketIds,
            isDone: true
        ),
        ]
        self.ticketDictionary[self.secondKey] = TicketListViewVM.dummySubTickets
        self.ticketDictionary[self.secondKey]?.append(TicketModel(title: "Add new subTickets", isDone: false, id: K.dummyId))
        
    }


    public func addBaseModelsAndReturnUUID()-> UUID {
        if self.ticketDictionary.count > 0 {
            fatalError("addBaseModelsAndReturnUUId method was called but found elements in ticketDictionary")
        }
        let id = UUID()
        self.ticketDictionary[id]  = []
        return id
    }
    
    public func addSubModelsAndReturnUUID()-> UUID {
        if self.ticketDictionary.count >= 2 {
            fatalError("addSubModelsAndReturnUUId method was called but found more than 1 elements in ticketDictionary")
        }
        let id = UUID()
        self.ticketDictionary[id]  = []
        return id
    }
    
    public func appendTicket(with ticket: TicketModel, super superId: UUID? = nil)  {
        
        if (superId == nil) {
            self.ticketDictionary[firstKey]?.append(ticket)
        } else {
            guard let superId = superId else {
                fatalError("fatal error")
            }
            self.ticketDictionary[secondKey]?.append(ticket)

            
            // Check if the super ticket is in base
            let baseCheckResult = checkIfBaseTicketsContainSuperandReturnIndex(superId)
            if let ticketIndexInBase = baseCheckResult {
                // if super is in base update its subticket list with new ticket id
            (self.ticketDictionary[firstKey]?[ticketIndexInBase])!.appendTicket(with: ticket.id)
                let tm = (self.ticketDictionary[firstKey]?[ticketIndexInBase])!
                let isSuccessfull = tm.getTickets().contains{ id in
                    id == ticket.id
                }
                if(!isSuccessfull){
                    fatalError("error")
                }
                return
            }
            
            
            // Check if the super ticket is in sub
            let subCheckResult = checkIfSubTicketsContainTicketIdAndReturnIndex(superId)
            if let ticketIndexInBase = subCheckResult {
                // if super is in sub update its subticket list with new ticket id
            (self.ticketDictionary[secondKey]?[ticketIndexInBase])!.appendTicket(with: ticket.id)
             
                
                return
            }
            
            // If not in base and not in sub list which means this super ticket is in a special space
//            let specialResultTuple = checkIfSpecialTicketsContainSuperandReturnPosAndIndex(superId)
            fatalError("not found anywhere")
        }
     }
    
    public func toggleTicketIsDone(id : UUID) {
        
        // Check if the super ticket is in sub
        let subCheckResult = checkIfSubTicketsContainTicketIdAndReturnIndex(id)
        if let ticketIndexInBase = subCheckResult {
            // if super is in sub update its subticket list with new ticket id
        (self.ticketDictionary[secondKey]?[ticketIndexInBase])!.toggleIsDone()
            return
        }
        fatalError("Ticket is not found")
    }
    
    public func getSubTicketCount(id: UUID) -> Int {
        // Check if the super ticket is in sub
        let subCheckResult = checkIfSubTicketsContainTicketIdAndReturnIndex(id)
        if let ticketIndexInSub = subCheckResult {
            // if super is in sub update its subticket list with new ticket id
           let ticketCount = (self.ticketDictionary[secondKey]?[ticketIndexInSub])!.ticketCount()
            return ticketCount
        }
        fatalError("Ticket is not found")
    }
    
    
    public func deleteTicket(with id : UUID, super superId: UUID? = nil)  {
        
        if (superId == nil) {
            // if superId is nil then this is a superTicket so we can remove if from superCollection
            self.ticketDictionary[firstKey]?.removeAll{ tm in
                tm.id == id
            }
            return
        } else {
            guard let superId = superId else {
                fatalError("fatal error")
            }
            // superId exists means that this ticket is a sub ticket
            self.ticketDictionary[secondKey]?.removeAll{ tm in
                tm.id == id
            }
            
            // We need to remove the id from the superTicket subTicketId List
            
            // Check if the super ticket is in base
            let baseCheckResult = checkIfBaseTicketsContainSuperandReturnIndex(superId)
            if let ticketIndexInSuper = baseCheckResult {
                // if super is in base update its subticket list with new ticket id
            (self.ticketDictionary[firstKey]?[ticketIndexInSuper])!.removeTicket(with: id)
                let tm = (self.ticketDictionary[firstKey]?[ticketIndexInSuper])!
                let doesContain = tm.getTickets().contains{ ticketId in
                    ticketId == id
                }
                if(doesContain){
                    fatalError("error")
                }
                return
            } else {
                
                // Check if the super ticket is in sub
                let subCheckResult = checkIfSubTicketsContainTicketIdAndReturnIndex(superId)
                if let ticketIndexInSub = subCheckResult {
                    // if super is in sub update its subticket list with new ticket id
                (self.ticketDictionary[secondKey]?[ticketIndexInSub])!.removeTicket(with: id)
                    let tm = (self.ticketDictionary[secondKey]?[ticketIndexInSub])!
                    let doesContain = tm.getTickets().contains{ ticketId in
                        ticketId == id
                    }
                    if(doesContain){
                        fatalError("error")
                    }
                    return
                }
                // If not in base and not in sub list which means this super ticket is in a special space
    //            let specialResultTuple = checkIfSpecialTicketsContainSuperandReturnPosAndIndex(superId)
                fatalError("not found anywhere")
            }
        }
     }
    
    
    private func checkIfBaseTicketsContainSuperandReturnIndex( _ superId: UUID) -> Int? {
        let baseListIndex =  self.ticketDictionary[firstKey]?.firstIndex {
            ticket  in
            ticket.id == superId
        }
        return baseListIndex
    }
    
    private func checkIfSubTicketsContainTicketIdAndReturnIndex(_ subId: UUID) -> Int? {
        let subListIndex =  self.ticketDictionary[secondKey]?.firstIndex {
            ticket  in
            ticket.id == subId
        }
        return subListIndex
    }
    
    private func checkIfSpecialTicketsContainSuperandReturnPosAndIndex(_ superId: UUID)-> (Int, Int)? {
        for i in 2...ticketDictionary.count - 1 {

            guard let nthKey = (Array(self.ticketDictionary.keys) as [UUID]?)?[i] else {
                fatalError("got into finding the nth key but not key not found in index \(i)")
            }
            
            let nthSpecialListIndex =  self.ticketDictionary[nthKey]?.firstIndex {
                ticket  in
                ticket.id == superId
            }
            
            if let nthSpecialListIndex = nthSpecialListIndex {
             return (i, nthSpecialListIndex)
            }
            
        }
        return nil
    }
    
    public func getSuperTickets() -> [TicketModel] {
        
        guard let fTickets = ticketDictionary[firstKey] else {
            fatalError("no TicketAvailable")
        }
        return fTickets
    }
        
    public func getTicket(with uuid: UUID) -> TicketModel {
        
       let ticketIfExistsInBase =  self.ticketDictionary[firstKey]?.first{
            ticket in
            ticket.id == uuid
        }
        
        if let ticketIfExistsInBase = ticketIfExistsInBase {
            return ticketIfExistsInBase
        }
        
        let ticketIfExistsInSub =  self.ticketDictionary[secondKey]?.first{
             ticket in
             ticket.id == uuid
         }
        
        if let ticketIfExistsInSub = ticketIfExistsInSub {
            return ticketIfExistsInSub
        }
        
        return TicketModel(title: "dummy", isDone: true)
    }
    
    public var superTicketCount: Int {
        let firstKey = self.ticketDictionary.first?.key ?? addBaseModelsAndReturnUUID()
        
        return self.ticketDictionary[firstKey]?.count ?? 0
    }
    
}

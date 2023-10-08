//
//  TicketModel.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import Foundation


final class TicketModelss : Identifiable, Codable {
    public let superId: UUID?
    public let  id: UUID
    var title: String
    
    public func setTitle(title:String){
        self.title = title
    }
    
    var isDone: Bool
    
    
    init(title: String, isDone: Bool, id: UUID = UUID(), superId: UUID? = nil)  {
        self.title = title
        self.isDone = isDone
        self.id = id
        self.superId = superId
    }
}




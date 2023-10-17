//
//  Constants.swift
//  Modularize
//
//  Created by FAO on 23/09/23.
//

import Foundation
import UIKit

struct K {
    static let ticketNoLimitToBeSpecial = 100
    static let dummyId = UUID(uuidString:"0C5749D6-EA21-4C76-95B4-9977F243BC0E")!
    static let editTitle = "Edit title"
    static let addNewTicket = "Add new ticket"
    static let batchAddNewTicket = "Batch add new ticket"
    static let deleteTicket = "Delete ticket"
    static let rateUs = "Rate us"
    static let aboutAuthor = "About Author"
    static var screenDepth = 0
    struct Color  {
        static let primary = UIColor.white
        static let secondary = UIColor.white.withAlphaComponent(0.5)
    }
    static private let colorArrayCollection: [[CGColor]] = [
        [
          UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0).cgColor, // Light Blue
          UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1.0).cgColor     // Indigo (Deep Purple)
        ],
        [
          UIColor(red: 250/255, green: 161/255, blue: 66/255, alpha: 1.0).cgColor, // Orange
          UIColor(red: 255/255, green: 93/255, blue: 104/255, alpha: 1.0).cgColor    // Red
        ],
        [
            UIColor(red: 133/255, green: 212/255, blue: 104/255, alpha: 1.0).cgColor, // Fresh Green
            UIColor(red: 23/255, green: 192/255, blue: 173/255, alpha: 1.0).cgColor // Turquoise
        ],
        [
            UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0).cgColor, // Crimson
            UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1.0).cgColor // Violet
        ],
    ]
    
    static func addGradient(view: UIView){

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArrayCollection[screenDepth]
        gradientLayer.locations = [0.0, 1.0] // Gradient starts from the top and goes to the bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Bottom
        gradientLayer.frame = view.bounds

        // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        screenDepth += 1
        if(screenDepth >= 4 ){
            screenDepth = 0
        }
    }
}

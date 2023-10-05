////
////  TicketCardTVC.swift
////  Modularize
////
////  Created by FAO on 26/09/23.
////
//
//import Foundation
//import UIKit
//
//
//
//final class TicketCardTVC : UICollectionViewCell {
//    static var cellIdentifier = "TicketCardTVC"
//    
////    private let horizontalClearPadding: UIView = {
////        let view = UIView()
////        view.translatesAutoresizingMaskIntoConstraints = false
//////        view.backgroundColor = .purple
////        return view
////    }()
//    
//    private let ticketCard: TicketCard = TicketCard()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubviews(
//            horizontalClearPadding
//            ,
//            ticketCard
//        )
//        contentView.addConstraintsToFullScreen(to: horizontalClearPadding)
//        
//        NSLayoutConstraint.activate([
//            
//            ticketCard.widthAnchor.constraint(equalToConstant: 300),
//            ticketCard.heightAnchor.constraint(equalToConstant: 400),
//            
//            ticketCard.centerXAnchor.constraint(equalTo: horizontalClearPadding.centerXAnchor),
//            ticketCard.centerYAnchor.constraint(equalTo: horizontalClearPadding.centerYAnchor),
//        
//        ])
//    }
//    
//    
//    public func configureTicketCard(vm: TicketListViewVM, tm: TicketModel) {
//        ticketCard.configure(with: tm, progress: tm.progress(vm: vm))
//            { ticketId in
//                return vm.getTicket(with: ticketId)
//            }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}



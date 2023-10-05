//
//  SubTicketVC.swift
//  Modularize
//
//  Created by FAO on 03/10/23.
//

import UIKit

class SubTicketVC: UIViewController {
    
    let vm: TicketListViewVM
    let mainTicketId : UUID
    let ticketCard: TicketCard
    let simpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let addNew = K.addNewTicket
    
    init(vm: TicketListViewVM, id: UUID, refreshSuperTableView: @escaping () -> Void) {
        
        self.vm = vm
        self.mainTicketId = id
        let ticketModel = self.vm.getTicket(with: id)
        ticketCard = TicketCard()
        
        super.init(nibName: nil, bundle: nil)
        ticketCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews(
            ticketCard
//            ,
//            simpleView
        )
        let ticketAtBlock = { ticketId in
            return vm.getTicket(with: ticketId)
                    }
        let reloadCell = {
//            collectionView.reloadItems(at: [indexPath])
        }
        let appendTicket: (TicketModel) -> Void = { tm in
            vm.appendTicket(with: tm, super: ticketModel.id)
        }
        let deleteTicketAt: (UUID) -> Void = { id in
            vm.deleteTicket(with: id, super: ticketModel.id)
        }
        let checkBoxTapped: (UUID) -> Void = { id in
            vm.toggleTicketIsDone(id: id)
        }
        let calculateProgress: () -> String =  {
            return ticketModel.progress(vm: vm)
        }
        let deleteCurrentTicket: () -> Void = {
            DispatchQueue.main.async {
                vm.deleteTicket(with: ticketModel.id)
                refreshSuperTableView()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        let pushToDetailScreen: (UUID, IndexPath) -> Void = { id, subIndexPath in
            let vc = SubTicketVC(vm: vm, id: id) {
                self.ticketCard.subTicketTableView.reloadRows(at: [subIndexPath], with: .automatic)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ticketCard.configure(
            with: ticketModel,
            calculateProgress: calculateProgress,
            getTicketAtblock: ticketAtBlock,
            reloadCell: reloadCell,
            appendTicket: appendTicket,
            deleteTicketAt: deleteTicketAt,
            checkBoxTapped: checkBoxTapped,
            deleteCurrentTicket: deleteCurrentTicket,
            pushToDetailScreen: pushToDetailScreen
        )
        self.addConstraints()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
//            ticketCard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),

//            ticketCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            ticketCard.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20),
//            ticketCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            ticketCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),

//            ticketCard.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
            ticketCard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            ticketCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ticketCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ticketCard.centerYAnchor.constraint(equalTo: view.centerYAnchor)

            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.title = "SubTickets"
        }
        
    }

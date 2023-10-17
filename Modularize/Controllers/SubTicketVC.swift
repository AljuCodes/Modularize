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
    var refreshSuperTVCell: (() -> Void)
    let simpleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let addNew = K.addNewTicket
    
    
    
    init(
        vm: TicketListViewVM,
        id: UUID,
        refreshSuperTableView: @escaping () -> Void,
        refreshSuperTVCell: @escaping () -> Void
    ) {
        
        self.vm = vm
        self.mainTicketId = id
        self.refreshSuperTVCell = refreshSuperTVCell
        
        let ticketModel = self.vm.getTicket(id)
        ticketCard = TicketCard()
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        ticketCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews(
            ticketCard
//            ,
//            simpleView
        )
        let ticketAtBlock = { ticketId in
            return vm.getTicket(ticketId)
                    }
        let renameTitle: (String) -> Void = { text in
            self.ticketCard.updateTitleLabel(titleLabel: text)
            vm.renameTicketTitle(id: id, title: text)
        }
        let appendTicket: (String, UUID?) -> Void = { title, superId in
            vm.appendTicket(title: title, superId: superId)
        }
        let deleteTicketAt: (UUID) -> Void = { id in
            vm.deleteTicket(id)
        }
        let checkBoxTapped: (UUID) -> Void = { id in
            vm.toggleTicketIsDone(id: id)
        }
        let calculateProgress: () -> String =  {
            return vm.getProgress(id)
        }
        let deleteCurrentTicket: () -> Void = {
                self.navigationController?.popViewController(animated: true)
            refreshSuperTableView()
            }
            
        let pushToDetailScreen: (UUID, IndexPath) -> Void = { id, subIndexPath in
            let vc = SubTicketVC(vm: vm, id: id) {
                vm.deleteTicket(id)
                self.ticketCard.subTicketTableView.reloadData()
            } refreshSuperTVCell: {
                DispatchQueue.main.async {
                    self.ticketCard.subTicketTableView.reloadRows(
                        at: [subIndexPath],
                        with: .automatic
                    )
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let getTicketCount = {
           return vm.getSubTicketCount(id)
        }
        let getSubTickets: (UUID) -> [TicketModel] = { id in
            return vm.getSubTickets(id)
        }
        ticketCard.configure(
            title: ticketModel.title,
            cardId: ticketModel.id,
            calculateProgress: calculateProgress,
            getTicketAtblock: ticketAtBlock,
            renameTitle: renameTitle,
            appendTicket: appendTicket,
            deleteTicketAt: deleteTicketAt,
            checkBoxTapped: checkBoxTapped,
            deleteCurrentTicket: deleteCurrentTicket,
            getRealTimeTicketCount: getTicketCount,
            pushToDetailScreen: pushToDetailScreen,
            getSubTickets: getSubTickets
        )
        self.addConstraints()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
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
        K.addGradient(view: view)
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            // This code will be executed when the view controller is popped
            print("View controller is being popped!")
            // Trigger your function here
            self.refreshSuperTVCell()
        }
    }
    
    }



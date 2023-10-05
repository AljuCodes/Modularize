//
//  ViewController.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import UIKit

class MainScreenVC: UIViewController {
    
    
    let vm: TicketListViewVM = .init()
    let ticketCollectionView =  TicketCollectionView()
    
    private var menuHandler:  UIActionHandler?
    
    private let addNew = K.addNewTicket
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ticketCollectionView)
        ticketCollectionView.collectionView.delegate = self
        ticketCollectionView.collectionView.dataSource = self
        view.addConstraintsToFullScreen(to: ticketCollectionView)
        //        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        setupMenuHandlerAndMenuButtons()
        navigationItem.title = "Modularize"
        }
    
        
    private func setupMenuHandlerAndMenuButtons(){
        menuHandler = { action in
            if action.title == self.addNew {
                let onOkay : (String) -> Void = { text in
                    let newTicket = TicketModel(title: text,  tickets: [K.dummyId], isDone: false)
                    self.vm.appendTicket(with: newTicket)
                    self.ticketCollectionView.collectionView.reloadData()
                }
                let presentDialog = { alertDialogController in
                    self.present(alertDialogController, animated: true, completion: nil)
                }
                let onTextField : (UITextField)-> Void = { textField in
                    textField.placeholder = "Enter ticket title here"
                }
                showDialogForAddingNewTicket(
                    onOkay: onOkay,
                    present: presentDialog,
                    onTextField: onTextField
                )
            }
        }
       if let menuHandler = menuHandler {
            let barButtonMenu = UIMenu(title: "", children: [
                UIAction(title: NSLocalizedString(addNew, comment: ""), image: UIImage(systemName: "plus"), handler: menuHandler),
                
                UIAction(title: NSLocalizedString("Settings", comment: ""), image: UIImage(systemName: "gear.circle"), handler: menuHandler),
                UIAction(title: NSLocalizedString("About", comment: ""), image: UIImage(systemName: "info.circle"), handler: menuHandler),
            ])
            //        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .compose)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), image: nil, primaryAction: nil, menu: barButtonMenu)
            
        }
    }
    
        @objc
        private func didTapSearch() {
            //    let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
            //    vc.navigationItem.largeTitleDisplayMode = .never
            //    navigationController?.pushViewController(vc, animated: true)
        }
        
    }





extension MainScreenVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.superTicketCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let ticketModel = vm.getSuperTickets()[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCardCell.cellIdentifier, for: indexPath) as?  TicketCardCell else {
            fatalError("fatal error")
        }
        let ticketAtBlock = { ticketId in
            return self.vm.getTicket(with: ticketId)
                    }
        let reloadCell = {
            collectionView.reloadItems(at: [indexPath])
        }
        let appendTicket: (TicketModel) -> Void = { tm in
            self.vm.appendTicket(with: tm, super: ticketModel.id)
        }
        let deleteTicketAt: (UUID) -> Void = { id in
            self.vm.deleteTicket(with: id, super: ticketModel.id)
        }
        let checkBoxTapped: (UUID) -> Void = { id in
            self.vm.toggleTicketIsDone(id: id)
        }
        let calculateProgress: () -> String =  {
            return ticketModel.progress(vm: self.vm)
        }
        let deleteCurrentTicket: () -> Void = {
            DispatchQueue.main.async {
                self.vm.deleteTicket(with: ticketModel.id)
                collectionView.deleteItems(at: [indexPath])
            }
        }
        let pushToDetailScreen: (UUID, IndexPath) -> Void = { id, subIndexPath in
            let vc = SubTicketVC(vm: self.vm, id: id){
                DispatchQueue.main.async {
                    
                    print("Delete item in \(subIndexPath)")
                    cell.ticketCard.subTicketTableView.deleteRows(at: [subIndexPath], with: .automatic)
                }
            }
           self.navigationController?.pushViewController(vc, animated: true)
            
        }
        cell.ticketCard.configure(
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
        return cell
    }
    
    
}


public func showDialogForAddingNewTicket(
    superTicketId: UUID? = nil,
    onOkay: @escaping (String)-> Void,
    present: (UIAlertController)-> Void,
    onTextField: @escaping (UITextField) -> Void
){
        let alertController = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        
        // Add a text field to the alert controller
        alertController.addTextField { textField in
            onTextField(textField)
        }
        // Add "OK" and "Cancel" buttons
        let okAction = UIAlertAction(title: "OK", style: .default) {  _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text {
                onOkay(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
       present(alertController)
    }

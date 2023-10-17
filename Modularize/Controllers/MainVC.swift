//
//  ViewController.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import UIKit
import StoreKit
import SafariServices


class MainScreenVC: UIViewController {
    
    
    let vm: TicketListViewVM = .init()
    let ticketCollectionView =  TicketCollectionView()
    
    private var menuHandler:  UIActionHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        K.addGradient(view: view)
        vm.printTickets()
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
            if action.title == K.aboutAuthor {
                guard let url = URL(string: "https://github.com/aljucodes") else {
                    fatalError("couldnt get the url")
                }
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true)
            }
            
            if action.title == K.rateUs {
                // Show rate us
                if let windowScene = self.view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }
        }
        if let menuHandler = menuHandler {
            let barButtonMenu = UIMenu(
                title: "", children: [
                    UIAction(
                        title: NSLocalizedString(K.rateUs, comment: ""),
                        image: UIImage(systemName: "star"),
                        handler: menuHandler
                    ),
                    UIAction(
                        title: NSLocalizedString(K.aboutAuthor, comment: ""),
                        image: UIImage(systemName: "info.circle"),
                        handler: menuHandler
                    ),
                ])
            
            
            //           color to red for menu items
            //        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .compose)
            let rightButton = UIBarButtonItem(image: UIImage(systemName:"ellipsis"), primaryAction: nil, menu: barButtonMenu)
            let secondBtn = UIBarButtonItem(image: UIImage(systemName: "plus"),  style: .plain, target: self, action:#selector( didTapAdd) )
            navigationItem.rightBarButtonItems = [rightButton, secondBtn ]
            navigationItem.rightBarButtonItem?.tintColor = .white
//            navigationItem.rightBarButtonItem.
            
            
        }
    }
    
    @objc
    private func didTapAdd(sender: AnyObject) {
        vm.printTickets()
        let onOkay : (String) -> Void = { text in
            self.vm.appendTicket(title: text, superId: nil)
            DispatchQueue.main.async {
                self.ticketCollectionView.collectionView.reloadData()
            }
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
    
    func showDeleteConfirmationAlert(id: UUID, cv: UICollectionView) {
        let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        // Create a UIAlertAction for the "Delete" option
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            DispatchQueue.main.async {
                self.vm.deleteTicket(id)
                cv.reloadData()
            }
        }
        
        // Create a UIAlertAction for the "Cancel" option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
}
    


extension MainScreenVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if vm.superTicketCount == 0 {
            return 1
        }  else {
            return vm.superTicketCount
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if vm.superTicketCount == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoTicketPlaceHolder.cellIdentifier, for: indexPath) as?  NoTicketPlaceHolder else {
                fatalError("fatal error")
            }
            return cell
        }
         let ticketModel = vm.getSuperTickets()[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCardCell.cellIdentifier, for: indexPath) as?  TicketCardCell else {
            fatalError("fatal error")
        }
        let vm = self.vm
        
        let ticketAtBlock = { ticketId in
            return vm.getTicket(ticketId)
                    }
        let renameTitle: (String) -> Void  = { text in
            cell.ticketCard.updateTitleLabel(titleLabel: text)
            vm.renameTicketTitle(id: ticketModel.id, title: text)
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
            return vm.getProgress(ticketModel.id)
        }
        let deleteCurrentTicket: () -> Void = {
            self.showDeleteConfirmationAlert(id: ticketModel.id, cv: collectionView)
        }
        
        let pushToDetailScreen: (UUID, IndexPath) -> Void = { id, subIndexPath in
            let vc = SubTicketVC(vm: vm, id: id) {
                vm.deleteTicket(id)
                cell.ticketCard.subTicketTableView.reloadData()
            } refreshSuperTVCell: {
                DispatchQueue.main.async {
                    cell.ticketCard.subTicketTableView.reloadRows(
                        at: [subIndexPath],
                        with: .automatic
                    )
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let getTicketCount = {
            return vm.getSubTicketCount(ticketModel.id)
        }
        let getSubTickets: (UUID) -> [TicketModel] = { id in
            return vm.getSubTickets(id)
        }

        cell.ticketCard.configure(
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



class NoTicketPlaceHolder : UICollectionViewCell {
    static let cellIdentifier = "NoTicketPlaceHolder"
    
    private let background: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        v.layer.cornerRadius = 40
        v.clipsToBounds = true
        return v
    }()
    
    private let infoText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Click '+' button to add your first ticket"
        label.numberOfLines = 0
        label.textColor = K.Color.primary
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(background)
        background.addSubview(infoText)
        addConstraints()
    }
    
    private func addConstraints(){
        addConstraintsToNonSafeFullScreen(to: background)
        NSLayoutConstraint.activate([
            infoText.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            infoText.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            infoText.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            infoText.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

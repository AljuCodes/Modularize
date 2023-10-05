//
//  TicketCard.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import UIKit

// refactor
final class TicketCard: UIView {
 
    private var ticketModel: TicketModel!
    
    private var getTicketAtBlock: ((UUID) -> TicketModel)?
    
    private var menuHandler:  UIActionHandler?
    
    private var reloadCell : (()-> Void)?
    private var appendTicket: ((TicketModel) -> Void)?
    private var deleteTicketAt: ((UUID)-> Void)?
    private var checkBoxTapped: ((UUID)-> Void)?
    private var calculateProgress: (()-> String)?
    private var deleteCurrentTicket: (() -> Void)?
    private var pushToDetailScreen: ((UUID, IndexPath) -> Void)?
    
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName:"ellipsis")!.rotate(radians: .pi/2)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.frame.size = CGSize(width: 40, height: 40)
//        button.imageView?.contentMode = .scaleToFill
//        button.isUserInteractionEnabled = true
//        button.isHidden = false

        return button
    }()
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    public var subTicketTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        //Setting the rowHeight allows the cell height to be adjusted automatically
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        tv.backgroundColor = .clear
        tv.register(TicketTVC.self, forCellReuseIdentifier: TicketTVC.cellIdentifier)

        return tv
    }()
    
    private var circularProgressBarView : CircularProgressBarView = {
        let cpbv = CircularProgressBarView(frame: .zero)
        return cpbv
    }()
    
    private func setupLayer(){
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: -4, height: 4)
        layer.shadowOpacity = 0.3
        layer.borderWidth  = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    
    private func showEditingDialog(){
        
        let onOkay = { text in
            self.ticketModel.setTitle(title: text)
            self.reloadCell?()
        }
        let present : (UIAlertController) -> Void = { ac in
            self.window?.rootViewController?.present(ac, animated: true, completion: nil)
        }
        let onTextField: (UITextField) -> Void = { textField in
            textField.placeholder = "Enter text here"
            textField.text = self.ticketModel.title
        }
        showDialogForAddingNewTicket(
            onOkay: onOkay,
            present: present,
            onTextField: onTextField
        )
    }
    
    private func showAddNewDialog(){
        let onOkay : (String) -> Void = { [weak self] text in
           guard let self = self else {
                return
            }
            let newTicket = TicketModel(title: text,  tickets: [K.dummyId], isDone: false)
            self.appendTicket?(newTicket)
            DispatchQueue.main.async {
                self.subTicketTableView.reloadData()
            }
        }
        let presentDialog: (UIAlertController)-> Void = { [weak self] alertDialogController in
            guard let self = self else {
                 return
             }
            self.window?.rootViewController?.present(alertDialogController, animated: true, completion: nil)
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
    
    private func showBatchAddDialog(){
        let alertController = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
              textField.placeholder = "Enter Code (less than 8 characters)"
            textField.delegate = self
          }

          alertController.addTextField { (textField) in
              textField.placeholder = "Enter positive integer"
              textField.keyboardType = .numberPad
          }

          alertController.addTextField { (textField) in
              textField.placeholder = "Enter start count"
              textField.keyboardType = .numberPad
          }
        // Add "OK" and "Cancel" buttons
        let okAction = UIAlertAction(title: "Generate", style: .default) { [weak self] _ in
                if let stringTextField = alertController.textFields?[0],
                         let intTextField = alertController.textFields?[1],
                         let startCountTextField = alertController.textFields?[2],
                         let inputString = stringTextField.text,
                         let inputValue = Int(intTextField.text ?? ""),
                         let startCount = Int(startCountTextField.text ?? ""),
                         inputValue > 0 {
                          // Generate the list of strings
                          var strings: [String] = []
                    for i in startCount..<(startCount + inputValue) {
                              let generatedString = "\(inputString) \(i)"
                              strings.append(generatedString)
                          }
                    for title in strings {
                        let tm =  TicketModel(title: title, tickets: [K.dummyId], isDone: false)
                        self?.appendTicket?(tm)
                    }
                    DispatchQueue.main.async {
                        self?.subTicketTableView.reloadData()
                    }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func setupMenuHandlerAndMenuButtons(){
        menuHandler = { action in
            switch action.title{
                case K.editTitle:
                self.showEditingDialog()
                case K.addNewTicket:
                self.showAddNewDialog()
            case K.batchAddNewTicket:
                self.showBatchAddDialog()
            case K.deleteTicket:
                self.deleteCurrentTicket?()
            default:
               return
            }
        }
       if let menuHandler = menuHandler {
            let barButtonMenu = UIMenu(title: "", children: [
                UIAction(title: NSLocalizedString(K.addNewTicket, comment: ""), image: UIImage(systemName: "plus"), handler: menuHandler),
                
                UIAction(title: NSLocalizedString(K.batchAddNewTicket, comment: ""), image: UIImage(systemName: "plus.square.on.square"), handler: menuHandler),
                UIAction(title: NSLocalizedString(K.editTitle, comment: ""), image: UIImage(systemName: "pencil"), handler: menuHandler),
                UIAction(title: NSLocalizedString(K.deleteTicket, comment: ""), image: UIImage(systemName: "trash"), handler: menuHandler),
            ])
            //        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .compose)
           moreButton.menu = barButtonMenu
           moreButton.showsMenuAsPrimaryAction = true
        }
    }
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews(
            titleLabel,
            circularProgressBarView,
            subTicketTableView,
            moreButton
        )
        addConstraints()
        setupLayer()
        clipsToBounds = true
        subTicketTableView.delegate = self
        subTicketTableView.dataSource = self
        setupMenuHandlerAndMenuButtons()
//        titleLabel.backgroundColor = .blue
//        moreButton.backgroundColor = .brown
//        circularProgressBarView.backgroundColor = .red
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: circularProgressBarView.leadingAnchor, constant: -10),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: circularProgressBarView.heightAnchor, multiplier: 1.0),
            
            
            circularProgressBarView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            circularProgressBarView.widthAnchor.constraint(equalToConstant: 60),
            circularProgressBarView.heightAnchor.constraint(equalToConstant: 60),
            
//            circularProgressBarView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30),
            moreButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            moreButton.leadingAnchor.constraint(equalTo: circularProgressBarView.trailingAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 60),
            moreButton.heightAnchor.constraint(equalToConstant: 60),
            
            subTicketTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTicketTableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            subTicketTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            subTicketTableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        ])
    }
    
    public func configure(
        with ticket: TicketModel,
        calculateProgress: @escaping () -> String,
        getTicketAtblock: @escaping (UUID) -> TicketModel,
        reloadCell: @escaping ()-> Void,
        appendTicket: @escaping (TicketModel) -> Void,
        deleteTicketAt: @escaping (UUID) -> Void,
        checkBoxTapped: @escaping (UUID) -> Void,
        deleteCurrentTicket: @escaping ()-> Void,
        pushToDetailScreen: @escaping (UUID, IndexPath)-> Void
    ){
        self.calculateProgress = calculateProgress
        self.getTicketAtBlock = getTicketAtblock
        self.reloadCell = reloadCell
        self.appendTicket = appendTicket
        self.deleteTicketAt = deleteTicketAt
        self.checkBoxTapped = checkBoxTapped
        self.deleteCurrentTicket = deleteCurrentTicket
        self.pushToDetailScreen = pushToDetailScreen
        titleLabel.text = ticket.title
        self.ticketModel = ticket
        subTicketTableView.reloadData()
        circularProgressBarView.progressAnimation(
            value: Float(calculateProgress())!
        )
    }
}


extension TicketCard : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.ticketModel.ticketCount()
//        print("we got subTicketCount \(count) for ticket \(self.ticketModel.title)")
        if(count == 0){
            print("we got zero count")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Item was tapped")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let ticketModelId = self.ticketModel.getTickets()[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TicketTVC.cellIdentifier,
            for: indexPath) as? TicketTVC, let ticketModel = getTicketAtBlock?(ticketModelId)
               else {
                   return UITableViewCell()
               }
//        cell.backgroundColor = .clear
//        cell.backgroundColor = randomColor()
        cell.configure(tm:  ticketModel){ 
            super.showToast(message: "Double tap to delete", duration: 500)
        } deleteTicket: {
            self.deleteTicketAt?(ticketModelId)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        } onCheckBoxTapped: {
            self.checkBoxTapped?(ticketModelId)
            let newProgress = self.calculateProgress?()
            guard let newProgress = newProgress, let value = Float(newProgress) else {
                fatalError("cannot convert value")
            }
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.circularProgressBarView.progressAnimation(
                    value: value
                )
            }
        } pushToDetailScreen: {
            self.pushToDetailScreen?(ticketModel.id, indexPath)
        }
        return cell
    }
    private func randomColor()-> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
         )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// textField delegate

extension TicketCard : UITextFieldDelegate {
    // Implement the UITextFieldDelegate method to limit character count
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 8 // Limit to 8 characters
    }
}


 class TicketCardCell :  UICollectionViewCell {
    
     public static let cellIdentifier = "TicketCard"
     let ticketCard = TicketCard()
     
     
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(ticketCard)
         ticketCard.frame = contentView.frame
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
}

//
//  TicketCard.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import UIKit

// refactor
final class TicketCard: UIView {
 
    private var title: String!
    private var cardId: UUID!
    private var getTicketAtBlock: ((UUID) -> TicketModel)?
    private var menuHandler:  UIActionHandler?
    private var renameTitle : ((String)-> Void)?
    private var appendTicket: ((String, UUID?) -> Void)?
    private var getRealTimeTicketCount : (() -> Int)?
    private var deleteTicketAt: ((UUID)-> Void)?
    private var checkBoxTapped: ((UUID)-> Void)?
    private var calculateProgress: (()-> String)?
    private var deleteCurrentTicket: (() -> Void)?
    private var pushToDetailScreen: ((UUID, IndexPath) -> Void)?
    private var getSubTickets : ((UUID) -> [TicketModel])?
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName:"ellipsis")!.rotate(radians: .pi/2).withTintColor(K.Color.primary)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.frame.size = CGSize(width: 40, height: 40)
        return button
    }()
    
    public func updateTitleLabel( titleLabel: String){
        self.titleLabel.text = titleLabel
    }
    
    private let titleLabel : UILabel = {
        let label = MUILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        return label
    }()
    
    public var subTicketTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        //Setting the rowHeight allows the cell height to be adjusted automatically
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        tv.backgroundColor = .clear
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        tv.register(TicketTVC.self, forCellReuseIdentifier: TicketTVC.cellIdentifier)
        tv.register(PlusButton.self, forCellReuseIdentifier: PlusButton.cellIdentifier)
        return tv
    }()
    
    
    private var circularProgressBarView : CircularProgressBarView = {
        let cpbv = CircularProgressBarView(frame: .zero)
        return cpbv
    }()
    
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
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
    }
    
    private func setupLayer(){
        layer.cornerRadius = 28
//        layer.shadowColor = UIColor.label.cgColor0
        layer.shadowOffset = CGSize(width: -4, height: 4)
        layer.shadowOpacity = 0.3
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
        title: String,
        cardId: UUID,
        calculateProgress: @escaping () -> String,
        getTicketAtblock: @escaping (UUID) -> TicketModel,
        renameTitle: @escaping (String)-> Void,
        appendTicket: @escaping (String, UUID?) -> Void,
        deleteTicketAt: @escaping (UUID) -> Void,
        checkBoxTapped: @escaping (UUID) -> Void,
        deleteCurrentTicket: @escaping ()-> Void,
        getRealTimeTicketCount: @escaping ()-> Int,
        pushToDetailScreen: @escaping (UUID, IndexPath)-> Void,
        getSubTickets: @escaping (UUID) -> [TicketModel]
    ){
        if(title == "3"){
            print("this is it")
        }
        self.calculateProgress = calculateProgress
        self.getTicketAtBlock = getTicketAtblock
        self.renameTitle = renameTitle
        self.appendTicket = appendTicket
        self.deleteTicketAt = deleteTicketAt
        self.checkBoxTapped = checkBoxTapped
        self.deleteCurrentTicket = deleteCurrentTicket
        self.pushToDetailScreen = pushToDetailScreen
        self.getRealTimeTicketCount = getRealTimeTicketCount
        self.getSubTickets = getSubTickets
        titleLabel.text = title
        self.title = title
        self.cardId = cardId
        circularProgressBarView.progressAnimation(
            value: Float(calculateProgress())!
        )
        DispatchQueue.main.async {
            self.subTicketTableView.reloadData()
        }
    }
}

// MARK: TableView Delegate DataSource

extension TicketCard : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let subTickets = getSubTickets?(self.cardId)
        print("subTickets of ")
        guard let subTickets = subTickets else {
            fatalError("Function did not return a proper list")
        }
        if subTickets.isEmpty {
            return 1
        } else {
            return subTickets.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Item was tapped")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setupProgress(){
        let newProgress = self.calculateProgress?()
        guard let newProgress = newProgress, let value = Float(newProgress) else {
            fatalError("cannot convert value")
        }
        self.circularProgressBarView.progressAnimation(
            value: value
        )
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTickets = getSubTickets?(self.cardId)
        guard let subTickets = subTickets else {
            fatalError("Function did not return a proper list")
        }
        if(subTickets.isEmpty){
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlusButton.cellIdentifier,
                for: indexPath) as? PlusButton
                   else {
                       return UITableViewCell()
                   }
            cell.configure("Press button with three dots to view menu \nClick 'Add new subTicket' to add a single subTicket \nClick 'Batch add sub tickets' to add multiple tickets at once")
            
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
        }
        let cellTMId = subTickets[indexPath.row].id
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TicketTVC.cellIdentifier,
            for: indexPath) as? TicketTVC, let ticketModel = getTicketAtBlock?(cellTMId)
               else {
                   return UITableViewCell()
               }
        cell.configure(tm:  ticketModel){ 
            super.showToast(message: "Double tap to delete", duration: 500)
        } deleteTicket: {
            self.deleteTicketAt?(cellTMId)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            self.setupProgress()
        } onCheckBoxTapped: { [weak self] in
            guard let self = self else {
                fatalError("got weak self")
            }
            self.checkBoxTapped?(cellTMId)
            subTickets[indexPath.row].isDone.toggle()
            setupProgress()
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } pushToDetailScreen: {
            self.pushToDetailScreen?(cellTMId, indexPath)
        }
        print("the cell in TV in TicketCard with title \(ticketModel.title) is getting rebuild where isDone is \(ticketModel.isDone)")
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackgroundView
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


class PlusButton: UITableViewCell {
    static let cellIdentifier = "PlusButton"
    

    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = K.Color.primary
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()

    
    private let containerView: UIView = {
        // wrapper to contain all the subviews for the UITableViewCell
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        self.layer.cornerRadius = 10
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.shadowRadius = 5
                self.layer.shadowOpacity = 1

        contentView.addSubviews(
            containerView
        )
        containerView.addSubviews(
            titleLabel
        )
        addConstraint()
        }
    
    
    public func configure(_
        title: String){
            self.titleLabel.text = title
    }
    

    
    public func addConstraint(){
        NSLayoutConstraint.activate([
            
            
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor , constant:4.0),
                titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor , constant:-4.0),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor , constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Dialogs

extension TicketCard {
    
    
    private func showEditingDialog(){
        
        let onOkay: (String) -> Void = { text in
            self.renameTitle?(text)
        }
        let present : (UIAlertController) -> Void = { ac in
            self.window?.rootViewController?.present(ac, animated: true, completion: nil)
        }
        let onTextField: (UITextField) -> Void = { textField in
            textField.placeholder = "Enter text here"
            textField.text = self.title
        }
        showDialogForAddingNewTicket(
            onOkay: onOkay,
            present: present,
            onTextField: onTextField
        )
    }
    
    @objc
    public func plusButtonTapped(sender: AnyObject){
        print("This is working")
        showAddNewDialog()
    }
    
    private func showAddNewDialog(){
        let onOkay : (String) -> Void = { [weak self] text in
           guard let self = self else {
                return
            }
            self.appendTicket?(text, cardId)
            DispatchQueue.main.async {
                self.subTicketTableView.reloadData()
                self.circularProgressBarView.progressAnimation(value: Float((self.calculateProgress?())!)! )
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
              textField.placeholder = "Enter ticket count"
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
                    guard let strongSelf = self else {
                        fatalError("strong casting error")
                    }
                    for title in strings {
                        strongSelf.appendTicket?(title, strongSelf.cardId)
                    }
                    DispatchQueue.main.async {
                        strongSelf.subTicketTableView.reloadData()
                    }
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

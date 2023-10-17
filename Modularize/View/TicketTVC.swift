//
//  TicketTVC.swift
//  Modularize
//
//  Created by FAO on 22/09/23.
//

import UIKit

class TicketTVC : UITableViewCell {
    static let cellIdentifier = "ticketTVC"
    
    private var showToast: (()-> Void)?
    
    private var deleteTicket: (() -> Void)?
    
    private var onCheckBoxTapped: (() -> Void)?
    
    private var pushToDetailScreen: (()-> Void)?
    
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
    
    
    @objc
    private func labelTapped(){
        if(!checkBox.isChecked){
            pushToDetailScreen?()
        
        }
    }
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName:"trash")?.withTintColor(K.Color.primary, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setImage(UIImage(systemName: "trash.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        
        button.frame.size = CGSize(width: 40, height: 40)
        button.imageView?.contentMode = .scaleToFill
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    @objc
    private func buttonTapped(_ sender: UIButton){
        sender.isSelected = true
        print("button was tapped")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.isSelected = false
        }
        showToast?()
    }
    
    @objc
    private func handleDoubleTap(_ sender: UIButton){
        
      print("button was double tapped")
        deleteTicket?()
        
    }
    
    private let containerView: UIView = {
        // wrapper to contain all the subviews for the UITableViewCell
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let checkBox: CheckBox = {
        let cb = CheckBox()
        cb.frame.size = CGSize(width: 40, height: 40)
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        

        contentView.addSubviews(
            containerView
        )
        containerView.addSubviews(
            titleLabel
            ,
            deleteButton,
            checkBox
        )
        addConstraint()
        checkBox.setOnTap {
            self.onCheckBoxTapped?()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        titleLabel.addGestureRecognizer(tapGesture)
//        arrowButton.addGestureRecognizer(tapGesture)
        deleteButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2 // Set the number of taps required for a double tap
        deleteButton.addGestureRecognizer(doubleTapGesture)
    }
    
    
    public func configure(
        tm: TicketModel,
        showToast : @escaping ()-> Void,
        deleteTicket: @escaping ()-> Void,
        onCheckBoxTapped: @escaping ()-> Void,
        pushToDetailScreen: @escaping ()-> Void
    ){
        self.showToast = showToast
        self.deleteTicket = deleteTicket
        self.onCheckBoxTapped = onCheckBoxTapped
        self.pushToDetailScreen = pushToDetailScreen
        checkBox.isChecked = tm.isDone
        if checkBox.isChecked {
            titleLabel.attributedText = tm.title.strikeThrough()
            titleLabel.textColor = K.Color.secondary
        } else {
            titleLabel.attributedText = .none
            titleLabel.text = tm.title
            titleLabel.textColor = K.Color.primary
        }
    }
    

    
    public func addConstraint(){
        NSLayoutConstraint.activate([
            
            checkBox.widthAnchor.constraint(equalToConstant: 40),
            checkBox.heightAnchor.constraint(equalToConstant: 40),
            
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor , constant:4.0),
                titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor , constant:-4.0),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor , constant: 5),
                titleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5),
//
            
            deleteButton.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -6),
//            deleteButton.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -6),
//            deleteButton.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkBox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            arrowButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//
//            checkBox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
//            arrowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
    }
    override func prepareForReuse() {
        self.onCheckBoxTapped = nil
        self.deleteTicket = nil
        self.pushToDetailScreen = nil
        self.showToast =  nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

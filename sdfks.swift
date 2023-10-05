//import UIKit
//
//class CustomTableViewCell: UITableViewCell {
//    // Create a UIButton with a system image for the delete action
//    let deleteButton: UIButton = {
//        let button = UIButton()
//        let trashImage = UIImage(systemName: "trash.fill") // Use the system trash icon
//        button.setImage(trashImage, for: .normal)
//        button.tintColor = .red // Set the color of the icon
//        
//        // Adjust the size of the image (e.g., 32x32 points)
//        let imageSize = CGSize(width: 32, height: 32)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) // Adjust spacing
//        
//        return button
//    }()
//
//    // You can add additional UI elements here if needed
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        // Add the delete button as a subview
//        contentView.addSubview(deleteButton)
//
//        // Configure button constraints (you can customize these as needed)
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
//        ])
//        
//        // Add a target to the delete button to handle the tap action
//        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc func deleteButtonTapped() {
//        // Implement your delete action logic here
//        // You can use a delegate pattern, closure, or any other mechanism to notify the table view controller
//        // that the delete button was tapped for this specific cell.
//    }
//}

//
//  SetConstraintToFullScreen.swift
//  Rickism
//
//  Created by FAO on 13/09/23.
//

import Foundation
import UIKit

extension UIView {
    
    public func addConstraintsToFullScreen(to view: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    public func addConstraintsToNonSafeFullScreen(to view: UIView) {
        NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: topAnchor),
    view.leftAnchor.constraint(equalTo: leftAnchor),
    view.rightAnchor.constraint(equalTo: rightAnchor),
    view.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    }
    
    public func addSpinnerDefaultConstraints(to spinner: UIActivityIndicatorView) {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}




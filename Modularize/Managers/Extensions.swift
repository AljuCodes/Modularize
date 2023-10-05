//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Aljith Paul on 12/23/22.
//

import UIKit

extension UIView {
    /// Add multiple subviews
    /// - Parameter views: Variadic views
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    /// Check if current device is phone idiom
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}


public extension UIView {

     func showToast(message:String, duration:Int = 2000) {

        let toastLabel = UIPaddingLabel();
        toastLabel.padding = 10;
        toastLabel.translatesAutoresizingMaskIntoConstraints = false;
        toastLabel.backgroundColor = UIColor.darkGray;
        toastLabel.textColor = UIColor.white;
        toastLabel.textAlignment = .center;
        toastLabel.text = message;
        toastLabel.numberOfLines = 0;
        toastLabel.alpha = 0.9;
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds = true;

        self.addSubview(toastLabel);

        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.left, relatedBy:.greaterThanOrEqual, toItem:self, attribute:.left, multiplier:1, constant:20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.right, relatedBy:.lessThanOrEqual, toItem:self, attribute:.right, multiplier:1, constant:-20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.bottom, relatedBy:.equal, toItem:self, attribute:.bottom, multiplier:1, constant:-20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1, constant:0));

        UIView.animate(withDuration:0.5, delay:Double(duration) / 1000.0, options:[], animations: {

            toastLabel.alpha = 0.0;

        }) { (Bool) in

            toastLabel.removeFromSuperview();
        }
    }
}


import UIKit

@IBDesignable class UIPaddingLabel: UILabel {

    private var _padding:CGFloat = 0.0;

    public var padding:CGFloat {

        get { return _padding; }
        set {
            _padding = newValue;

            paddingTop = _padding;
            paddingLeft = _padding;
            paddingBottom = _padding;
            paddingRight = _padding;
        }
    }

    @IBInspectable var paddingTop:CGFloat = 0.0;
    @IBInspectable var paddingLeft:CGFloat = 0.0;
    @IBInspectable var paddingBottom:CGFloat = 0.0;
    @IBInspectable var paddingRight:CGFloat = 0.0;

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top:paddingTop, left:paddingLeft, bottom:paddingBottom, right:paddingRight);
        super.drawText(in: rect.inset(by: insets));
    }

    override var intrinsicContentSize: CGSize {

        get {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize;
            intrinsicSuperViewContentSize.height += paddingTop + paddingBottom;
            intrinsicSuperViewContentSize.width += paddingLeft + paddingRight;
            return intrinsicSuperViewContentSize;
        }
    }
}


//
//  CircularProgressBarView.swift
//  TestCircularProgressBar
//
//  Created by Cem Kazım on 8.11.2020.
//
import UIKit

class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    private let percentageLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setTitle(value: String){
        percentageLabel.text = value
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        createCircularPath()
        addSubview(percentageLabel)
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(
                arcCenter: CGPoint(
                    x: 30,
                    y: 30
                ),
                radius: 24,
                startAngle: startPoint,
                endAngle: endPoint,
                clockwise: true
            )
        
        let progressPath = UIBezierPath(
            arcCenter: CGPoint(
                x: 30,
                y: 30
            ),
            radius: 23.5,
            startAngle: startPoint,
            endAngle: endPoint,
            clockwise: true
        )
//             circleLayer path defined to circularPath
            circleLayer.path = circularPath.cgPath
            // ui edits
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round
            circleLayer.lineWidth = 10.0
            circleLayer.strokeEnd = 1
            circleLayer.strokeColor = UIColor.black.cgColor
            // added circleLayer to layer
            layer.addSublayer(circleLayer)
           
//             progressLayer path defined to circularPath
            progressLayer.path = progressPath.cgPath
//             ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 8.0
            progressLayer.strokeEnd = 0
            progressLayer.strokeColor = UIColor.green.cgColor
            // added progressLayer to layer
            layer.addSublayer(progressLayer)
        }
    
    func progressAnimation(duration: TimeInterval = 0.8, value: Float) {
        self.setTitle(value: String(describing: Int(value)) + "%")
//    print("value present in circular animation \(value)")
            // created circularProgressAnimation with keyPath
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = duration
            circularProgressAnimation.toValue = (value/100)
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        }
}

//
//  UIView+Extension.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top {
            topAnchor
                .constraint(equalTo: top, constant: paddingTop)
                .isActive = true
        }
        
        if let left {
            leftAnchor
                .constraint(equalTo: left, constant: paddingLeft)
                .isActive = true
        }
        
        if let bottom {
            bottomAnchor
                .constraint(equalTo: bottom, constant: -paddingBottom)
                .isActive = true
        }
        
        if let right {
            rightAnchor
                .constraint(equalTo: right, constant: -paddingRight)
                .isActive = true
        }
        
        if let leading {
            leadingAnchor
                .constraint(equalTo: leading, constant: paddingRight)
                .isActive = true
        }
                
        if let trailing {
            trailingAnchor
                .constraint(equalTo: trailing, constant: -paddingRight)
                .isActive = true
        }

        if let width {
            widthAnchor
                .constraint(equalToConstant: width)
                .isActive = true
        }
        
        if let height {
            heightAnchor
                .constraint(equalToConstant: height)
                .isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
        centerYAnchor
            .constraint(equalTo: view.centerYAnchor,
                        constant: yConstant!)
            .isActive = true
    }
    
    func centerX(inView view: UIView,
                 topAnchor: NSLayoutYAxisAnchor? = nil,
                 paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
        
        if let topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor,
                                      constant: paddingTop!)
            .isActive = true
        }
    }
    
    func centerY(inView view: UIView,
                 leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat? = nil,
                 constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor
            .constraint(equalTo: view.centerYAnchor,
                        constant: constant!)
            .isActive = true
        
        if let leftAnchor, let padding = paddingLeft {
            self.leftAnchor
                .constraint(equalTo: leftAnchor, constant: padding)
                .isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor
            .constraint(equalToConstant: width)
            .isActive = true
        heightAnchor
            .constraint(equalToConstant: height)
            .isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

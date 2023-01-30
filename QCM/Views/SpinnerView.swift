//
//  SpinnerView.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import UIKit

final class SpinnerView {
    var parentView: UIView?
    private lazy var container: UIView? = {
        let container = UIView(frame: parentView?.bounds ?? .zero)
        container.backgroundColor = UIColor.init(red: 0.5, green: 0.5,
                                             blue: 0.5, alpha: 0.5)
        parentView?.addSubview(container)
        return container
    } ()

    func show() {
        guard let container
        else { return }
        
        let activityIndicatorView = UIActivityIndicatorView (style: .large)
        activityIndicatorView.center = container.center
        activityIndicatorView.startAnimating()
        container.addSubview(activityIndicatorView)
    }
    
    func dismiss() {
        guard let container
        else { return }
        container.removeFromSuperview()
    }
}

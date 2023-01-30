//
//  BadgeView.swift
//  QCM
//
//  Created by Sofien Benharchache on 30/01/2023.
//

import UIKit

final class BadgeView: UIView {
    private lazy var circleView: UIView = {
        let size = CGSize(width: 25, height: 25)
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: size))
        view.backgroundColor = .QCMBlue
        view.layer.cornerRadius = 25/2
        
        return view
    }()
    
    private lazy var clearCircleView: UIView = {
        let size = CGSize(width: 25, height: 25)
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: size))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 25/2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    
    var hide: Bool {
        didSet { circleView.isHidden = hide }
    }
    
    override init(frame: CGRect) {
        self.hide = false
        super.init(frame: frame)
        addSubview(circleView)
        addSubview(clearCircleView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

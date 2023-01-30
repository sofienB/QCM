//
//  ChoiceView.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import UIKit

final class ChoiceView: UIView {
    private(set) lazy var isSelected: Bool = false {
        didSet { badge.hide = !isSelected }
    }
    var choiceId: UInt = 0
    var delegate: ChoiceViewProtocol?
    
    private var informationData: String?

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private var badge: BadgeView = {
        let label = BadgeView(frame: .zero)
        return label
    }()

    private lazy var information: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .label
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showInformation))
        imageView.isUserInteractionEnabled = true

        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16.0
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 6)
        stack.isLayoutMarginsRelativeArrangement = true
        [self.badge, self.label, self.information].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    init(choice: Choice) {
        super.init(frame: .zero)
        self.addSubview(container)
        
        configureConstraint()
        configureView()
        
        choiceId = choice.id
        badge.hide = !isSelected
        label.text = choice.name
        information.isHidden = choice.description == nil
        informationData = choice.description
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onClick))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        container.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor)

        badge.anchor(width: 25, height: 25)
        information.anchor(width: 25, height: 25)
    }
    
    @objc func onClick(sender : UITapGestureRecognizer) {
        isSelected = !isSelected
        delegate?.didUpdate(state: isSelected)
    }
    
    @objc func showInformation(sender : UITapGestureRecognizer) {
        if let informationData {
            delegate?.show(information: informationData)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .QCMBlue.withAlphaComponent(0.2)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 0.5
    }
}

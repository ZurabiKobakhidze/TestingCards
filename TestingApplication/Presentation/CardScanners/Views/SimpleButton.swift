//
//  SimpleButton.swift
//  TestingApplication
//
//  Created by Zurabi Kobakhidze - External on 22/12/23.
//

import UIKit

typealias ButtonActionHandler = (() -> Void)?

class SimpleButton: UIButton {
    private var handler: ButtonActionHandler
    
    init(title: String, handler: ButtonActionHandler = nil) {
        self.handler = handler
        super.init(frame: .zero)
        setupAppearance()
        setTitle(title)
        addTarget(self, action: #selector(onButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SimpleButton {
    func setupAppearance() {
        setupUI()
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        setTitleColor(.blue, for: .normal)
        titleLabel?.textAlignment = .center
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func onButton() {
        handler?()
    }
}

extension SimpleButton {
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    func setHandler(_ handler: ButtonActionHandler) {
        self.handler = handler
    }
}

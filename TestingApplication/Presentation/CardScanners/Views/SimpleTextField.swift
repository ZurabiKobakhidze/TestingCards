//
//  SimpleTextField.swift
//  TestingApplication
//
//  Created by Zurabi Kobakhidze - External on 22/12/23.
//

import UIKit

class SimpleTextField: UITextField {
    init(input: String = "", placeholder: String = "") {
        super.init(frame: .zero)
        setupAppearance()
        setInput(input)
        setPlaceholder(placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SimpleTextField {
    func setupAppearance() {
        setupUI()
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        textColor = .white
        returnKeyType = .done
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
        addTarget(self, action: #selector(onDone), for: .editingDidEndOnExit)
    }
}

extension SimpleTextField {
    func setInput(_ input: String?) {
        text = input
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
}

private extension SimpleTextField {
    @objc func onDone() {
        resignFirstResponder()
    }
}

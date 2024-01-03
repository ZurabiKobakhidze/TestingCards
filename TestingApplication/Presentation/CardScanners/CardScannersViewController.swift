//
//  CardScannersViewController.swift
//  TestingApplication
//
//  Created by Zurabi Kobakhidze - External on 22/12/23.
//

import UIKit

class CardScannersViewController: UIViewController {
    private lazy var textFieldsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [panTextField, dateTextField, holderTextField])
        stack.distribution = .fill
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let panTextField: SimpleTextField = .init(placeholder: "5567 3455 45** ****")
    
    private let dateTextField: SimpleTextField = .init(placeholder: "07/27")
    
    private let holderTextField: SimpleTextField = .init(placeholder: "ZURABI KOBAKHIDZE")
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sharkCardScannerButton, stripeCardScannerButton])
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let sharkCardScannerButton: SimpleButton = .init(title: "SharkCardScanner SDK")
    
    private let stripeCardScannerButton: SimpleButton = .init(title: "StripeCardScanner SDK")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        configureAppearance()
    }
}

private extension CardScannersViewController {
    func setupAppearance() {
        setupUI()
        setupTextFieldsStack()
        setupButtonStack()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackground)))
    }
    
    func setupTextFieldsStack() {
        view.addSubview(textFieldsStack)
        NSLayoutConstraint.activate([
            textFieldsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textFieldsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textFieldsStack.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    func setupButtonStack() {
        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: textFieldsStack.safeAreaLayoutGuide.bottomAnchor, constant: 24),
            buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
    }
}

private extension CardScannersViewController {
    func configureAppearance() {
        configureSharkCardScannerButton()
        configureStripeCardScannerButton()
    }
    
    func configureSharkCardScannerButton() {
        sharkCardScannerButton.setHandler(sharkCardScanHandler)
    }

    func configureStripeCardScannerButton() {
        stripeCardScannerButton.setHandler(stripeCardScanHandler)
    }
}

private extension CardScannersViewController {
    @objc func onBackground() {
        view.endEditing(true)
    }
}

//MARK: - Shark Card Scan

import SharkCardScan

private extension CardScannersViewController {
    var sharkCardScanHandler: ButtonActionHandler {
        { [weak self] in
            let viewModel = CardScanViewModel(noPermissionAction: { [weak self] in
                self?.cardNoPermissionAction()
            },
                                              successHandler: { [weak self] response in
                self?.cardSuccessHandler(response)
            })
            viewModel.insturctionText = "Place your card inside rectangle to scan"
            let scanner = SharkCardScanViewController(viewModel: viewModel,
                                                      styling: DefaultStyling())
            scanner.modalPresentationStyle = .formSheet
            
            self?.present(scanner, animated: true)
        }
    }
    
    private func cardNoPermissionAction() {
        print("SHARK CARD SCAN: NO PERMISSION")
    }
    
    private func cardSuccessHandler(_ response: CardScannerResponse) {
        panTextField.setInput(response.number)
        dateTextField.setInput(response.expiry)
        holderTextField.setInput(response.holder)
        print("SHARK CARD SCAN: \(response)")
    }
}

//MARK: - Stripe Card Scan

import StripeCardScan

private extension CardScannersViewController {
    var stripeCardScanHandler: ButtonActionHandler {
        { [weak self] in
            guard let self = self else { return }
            let cardScanSheet = CardScanSheet()
            cardScanSheet.present(from: self,
                                  completion: { [weak self] result in
                switch result {
                case .completed(let scannedCard):
                    print("STRIPE CARD SCAN: \(scannedCard)")
                    self?.panTextField.setInput(scannedCard.pan)
                    /**
                    Can't access expiryMonth, expiryYear and name, because it is written as @_spi(STP) public let
                     */
//                    self?.dateTextField.setInput([scannedCard.expiryMonth, "/", scannedCard.expiryYear].joined())
//                    self?.holderTextField.setInput(scannedCard.name)
                    self?.dateTextField.setInput("")
                    self?.holderTextField.setInput("")
                case .canceled:
                    print("STRIPE CARD SCAN: CANCELED")
                case .failed(let error):
                    print("STRIPE CARD SCAN: ERROR -> ", error.localizedDescription)
                }
            },
                                  animated: true)

        }
    }
}

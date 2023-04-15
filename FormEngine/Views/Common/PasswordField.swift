//
//  PasswordField.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

protocol PasswordFieldProtocol {
    var text: String? { get set }
}

class PasswordField: UIView, PasswordFieldProtocol {
    private var textField: UITextField!
    weak var delegate: PasswordFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleEdit), for: .editingChanged)
        self.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    @objc func handleEdit() {
        delegate?.passwordField(self, didEdit: textField.text)
    }
}

// MARK: - PasswordFieldDelegate
protocol PasswordFieldDelegate: NSObjectProtocol {
    func passwordField(_ passwordField: PasswordField, didEdit text: String?)
}

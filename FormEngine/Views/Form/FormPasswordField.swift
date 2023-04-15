//
//  FormPasswordField.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

class FormPasswordField: FormView<PasswordField> {
    weak var delegate: FormPasswordFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FormPasswordFieldDelegate
protocol FormPasswordFieldDelegate: NSObjectProtocol {
    func formPasswordField(_ formPasswordField: FormPasswordField, didEdit text: String?)
}

// MARK: - PasswordFieldDelegate
extension FormPasswordField: PasswordFieldDelegate {
    func passwordField(_ passwordField: PasswordField, didEdit text: String?) {
        delegate?.formPasswordField(self, didEdit: text)
        errorMessage.text = nil
    }
}

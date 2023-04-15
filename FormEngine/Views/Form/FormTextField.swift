//
//  FormTextField.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

class FormTextField: FormView<UITextField> {
    weak var delegate: FormTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.textColor = .black
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 6
        contentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        contentView.addTarget(self, action: #selector(handleEdit), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleEdit() {
        delegate?.formTextField(self, didEdit: contentView.text)
        errorMessage.text = nil
    }
}

// MARK: - FormTextFieldDelegate
protocol FormTextFieldDelegate: NSObjectProtocol {
    func formTextField(_ formTextField: FormTextField, didEdit text: String?)
}

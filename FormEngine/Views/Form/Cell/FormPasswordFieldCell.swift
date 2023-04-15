//
//  FormPasswordFieldCell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

class FormPasswordFieldCell: UITableViewCell, FormGeneratorCell {
    var passwordField: FormPasswordField!
    weak var delegate: FormGeneratorCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        passwordField = FormPasswordField(frame: .zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.delegate = self
        contentView.addSubview(passwordField)
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passwordField.topAnchor.constraint(equalTo: contentView.topAnchor),
            passwordField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with data: FormGeneratorCellData) {
        passwordField.titleLabel.text = data.row.title
        passwordField.contentView.text = data.value as? String
        passwordField.errorMessage.text = data.errorMessage
    }
}

// MARK: - FormPasswordFieldDelegate
extension FormPasswordFieldCell: FormPasswordFieldDelegate {
    func formPasswordField(_ formPasswordField: FormPasswordField, didEdit text: String?) {
        delegate?.formGeneratorCell(self, updateValueFor: text)
    }
}

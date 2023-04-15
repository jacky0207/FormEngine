//
//  FormTextFieldCell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

class FormTextFieldCell: UITableViewCell, FormGeneratorCell {
    var textField: FormTextField!
    weak var delegate: FormGeneratorCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        textField = FormTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with data: FormGeneratorCellData) {
        textField.titleLabel.text = data.row.title
        textField.contentView.text = data.value as? String
        textField.contentView.keyboardType = data.row.uiKeyboardType
        textField.errorMessage.text = data.errorMessage
    }
}

// MARK: - FormTextFieldDelegate
extension FormTextFieldCell: FormTextFieldDelegate {
    func formTextField(_ formTextField: FormTextField, didEdit text: String?) {
        delegate?.formGeneratorCell(self, updateValueFor: text)
    }
}

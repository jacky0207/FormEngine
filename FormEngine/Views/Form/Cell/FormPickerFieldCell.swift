//
//  FormPickerFieldCell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

class FormPickerFieldCell: UITableViewCell, FormGeneratorCell {
    var textField: FormPickerField!
    weak var delegate: FormGeneratorCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        textField = FormPickerField(frame: .zero)
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
        textField.contentView.items = data.row.items ?? []
        textField.contentView.selectRow(for: data.value as? Int ?? -1)
        textField.errorMessage.text = data.errorMessage
    }
}

// MARK: - FormPickerFieldDelegate
extension FormPickerFieldCell: FormPickerFieldDelegate {
    func formPickerField(_ formPickerField: FormPickerField, didSelect id: Int) {
        delegate?.formGeneratorCell(self, updateValueFor: id)
    }
}

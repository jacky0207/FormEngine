//
//  FormPickerField.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

class FormPickerField: FormView<PickerField> {
    weak var delegate: FormPickerFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FormPickerFieldDelegate
protocol FormPickerFieldDelegate: NSObjectProtocol {
    func formPickerField(_ formPickerField: FormPickerField, didSelect id: Int)
}

// MARK: - PickerFieldDelegate
extension FormPickerField: PickerFieldDelegate {
    func pickerField(_ pickerField: PickerField, didSelect id: Int) {
        delegate?.formPickerField(self, didSelect: id)
        errorMessage.text = nil
    }
}

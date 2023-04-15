//
//  FormRowType+Cell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

extension FormRowType {
    var cellClass: AnyClass {
        switch self {
        case .button:
            return FormButtonCell.self
        case .title:
            return FormTitleCell.self
        case .textField:
            return FormTextFieldCell.self
        case .picker:
            return FormPickerFieldCell.self
        case .passwordField:
            return FormPasswordFieldCell.self
        }
    }
}

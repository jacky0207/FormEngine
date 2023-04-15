//
//  FormGeneratorValidator.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-12.
//

import Foundation

protocol FormGeneratorValidation {
    var errorMessages: [String: String] { get set }
    func validateForm(_ form: Form, with values: [String: Any])
}

class FormGeneratorValidator: FormGeneratorValidation {
    var errorMessages: [String: String] = [:]

    private func match(_ pattern: String, for string: String) -> Bool {
        return string.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func validateForm(_ form: Form, with values: [String: Any]) {
        for row in form.rows {
            let value = String(describing: values[row.id] ?? "")
            let error = row.validations?.first { !match($0.regex, for: value) }  // display 1st error message
            errorMessages[row.id] = error?.message
        }
    }
}

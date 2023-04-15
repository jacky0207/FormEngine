//
//  Form.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

public struct Form: Decodable {
    var rows: [FormRow]
}

public struct FormRow: Decodable, Hashable {
    public static func == (lhs: FormRow, rhs: FormRow) -> Bool {
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id: String
    var type: Int
    var title: String?
    var keyboardType: Int?
    var items: [PickerItem]?
    var validations: [FormRowValidation]?
    var action: Int?
}

// MARK: - FormRowValidation
struct FormRowValidation: Decodable {
    var regex: String
    var message: String
}

// MARK: - FormRowAction
enum FormRowAction: Int {
    case submit = 0
    case next
}

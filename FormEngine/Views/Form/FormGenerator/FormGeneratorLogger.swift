//
//  FormGeneratorLogger.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

struct FormGeneratorLogger {
    static let shared = FormGeneratorLogger()

    private init() {}

    enum LogEvent {
        case update, select, error
    }

    func log(_ content: String) {
        var message = ""
        message += "info -> \(content)"
        print(message)
    }

    func log(_ row: FormRow, with value: Any?) {
        var message = ""
        message += "\(LogEvent.update) -> "
        message += "id: \"\(row.id)\""
        if value is String {
            message += ", value: \"\(value ?? "nil")\""
        } else {
            message += ", value: \(String(describing: value ?? "nil"))"
        }
        print(message)
    }

    func log(_ row: FormRow, forAction action: FormRowAction) {
        var message = ""
        message += "\(LogEvent.select) -> "
        message += "id: \"\(row.id)\""
        message += ", action: \(action)"
        print(message)
    }

    func log(_ row: FormRow, forError error: String) {
        var message = ""
        message += "\(LogEvent.error) -> "
        message += "id: \"\(row.id)\""
        message += ", message: \(error)"
        print(message)
    }
}

//
//  FormGeneratorView.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

protocol FormGenerator {
    var values: [String: Any] { get set }

    var validator: FormGeneratorValidator { get set }
    var form: Form? { get }
    func formRow(for id: String) -> FormRow?
    func submitForm()

    func reloadData()
    func reloadHeight()
}

open class FormGeneratorView: UIView, UITableViewDataSource, FormGenerator {
    var tableView: UITableView!
    weak var formDataSource: FormGeneratorViewDataSource?
    weak var formDelegate: FormGeneratorViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = TableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(FormUnknownCell.self, forCellReuseIdentifier: String(describing: FormUnknownCell.self))
        for cellClass in FormRowType.allCases.map({ $0.cellClass }) {
            tableView.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
        }
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Value
    var values: [String: Any] = [:]

    // MARK: Form
    var validator = FormGeneratorValidator()

    var form: Form? {
        return formDataSource?.form(in: self)
    }

    func formRow(for id: String) -> FormRow? {
        return form?.rows.first { $0.id == id }
    }

    func submitForm() {
        formDelegate?.formGeneratorView(self, didSubmit: values)
    }

    // MARK: Reload
    func reloadData() {
        tableView.reloadData()
    }

    func reloadHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(0, (form?.rows.count ?? 0) * 2 - 1)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 {  // add space between row
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormUnknownCell.self), for: indexPath)
            return cell
        }

        let row = form!.rows[indexPath.row / 2]
        guard let type = FormRowType(rawValue: row.type) else {
            print("unsupported type: \(row.type)")
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormUnknownCell.self), for: indexPath)
            return cell
        }
        let cellClass: AnyClass = type.cellClass
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as! (UITableViewCell & FormGeneratorCell)
        cell.update(with: FormGeneratorCellData(row: row, value: values[row.id], errorMessage: validator.errorMessages[row.id]))
        cell.delegate = self
        return cell
    }
}

// MARK: - FormGeneratorViewDataSource
protocol FormGeneratorViewDataSource: NSObjectProtocol {
    func form(in view: FormGeneratorView) -> Form
}

// MARK: - FormGeneratorViewDelegate
protocol FormGeneratorViewDelegate: NSObjectProtocol {
    func formGeneratorView(_ view: FormGeneratorView, didSubmit values: [String: Any])
}

// MARK: - FormGeneratorCellDelegate
extension FormGeneratorView: FormGeneratorCellDelegate {
    func formGeneratorCell(_ cell: FormGeneratorCell, updateValueFor string: String?) {
        guard let indexPath = tableView.indexPath(for: cell as! UITableViewCell) else {
            return
        }
        // set value and error message
        // reload height for component height changed
        let data = form!.rows[indexPath.row / 2]
        values[data.id] = string
        validator.errorMessages[data.id] = nil
        FormGeneratorLogger.shared.log(data, with: string)
        reloadHeight()
    }

    func formGeneratorCell(_ cell: FormGeneratorCell, updateValueFor int: Int?) {
        guard let indexPath = tableView.indexPath(for: cell as! UITableViewCell) else {
            return
        }
        // set value and error message
        // reload height for component height changed
        let data = form!.rows[indexPath.row / 2]
        values[data.id] = int
        validator.errorMessages[data.id] = nil
        FormGeneratorLogger.shared.log(data, with: int)
        reloadHeight()
    }

    func formGeneratorCellDidSelect(_ cell: FormGeneratorCell) {
        guard let indexPath = tableView.indexPath(for: cell as! UITableViewCell) else {
            return
        }
        // identify action
        let data = form!.rows[indexPath.row / 2]
        guard let action = data.action else {
            print("missing action")
            return
        }
        guard let action = FormRowAction(rawValue: action) else {
            print("unsupported action: \(action)")
            return
        }
        FormGeneratorLogger.shared.log(data, forAction: action)
        // update error message and submit form
        FormGeneratorLogger.shared.log("values: \(values)")
        validator.validateForm(form!, with: values)
        reloadData()  // reload message
        if !validator.errorMessages.isEmpty {
            for error in validator.errorMessages {
                FormGeneratorLogger.shared.log(formRow(for: error.key)!, forError: error.value)
            }
            return
        }
        FormGeneratorLogger.shared.log("submit form")
        submitForm()
    }
}

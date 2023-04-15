//
//  PickerField.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-14.
//

import UIKit

protocol PickerFieldProtocol {
    var items: [PickerItem] { get set }
    func row(for id: Int) -> Int

    var selectedRow: Int { get }
    var selectedItem: PickerItem? { get }
    var selectedId: Int { get }

    func selectRow(_ row: Int)
    func selectRow(for id: Int)
}

class PickerField: UIView, PickerFieldProtocol {
    private var textField: UITextField!
    private var pickerView: UIPickerView!
    weak var delegate: PickerFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        pickerView = UIPickerView(frame: .zero)
        pickerView.dataSource = self
        pickerView.delegate = self

        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.inputView = pickerView
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var items: [PickerItem] = [] {
        didSet {
            pickerView.reloadAllComponents()
            selectRow(-1)
        }
    }

    func row(for id: Int) -> Int {
        return items.firstIndex { $0.id == id } ?? -1
    }

    var selectedRow: Int {
        return pickerView.selectedRow(inComponent: 0)
    }

    var selectedItem: PickerItem? {
        let row = selectedRow
        if row < 0 || row >= items.count {
            return nil
        }
        return items[row]
    }

    var selectedId: Int {
        return selectedItem?.id ?? -1
    }

    func selectRow(_ row: Int) {
        if row < 0 || row >= items.count {
            pickerView.selectRow(-1, inComponent: 0, animated: false)
            textField.text = nil
            return
        }
        pickerView.selectRow(row, inComponent: 0, animated: false)
        textField.text = items[row].value
    }

    func selectRow(for id: Int) {
        selectRow(row(for: id))
    }
}

// MARK: - PickerFieldDelegate
protocol PickerFieldDelegate: NSObjectProtocol {
    func pickerField(_ pickerField: PickerField, didSelect id: Int)
}

// MARK: - UIPickerViewDataSource
extension PickerField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].value
    }
}

// MARK: - UIPickerViewDelegate
extension PickerField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = items[row]
        textField.text = item.value
        delegate?.pickerField(self, didSelect: item.id)
    }
}


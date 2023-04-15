//
//  FormGeneratorCell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

protocol FormGeneratorCell {
    var delegate: FormGeneratorCellDelegate? { get set }
    func update(with data: FormGeneratorCellData)
}

struct FormGeneratorCellData {
    var row: FormRow
    var value: Any?
    var errorMessage: String?
}

// MARK: - FormGeneratorCellDelegate
protocol FormGeneratorCellDelegate: NSObjectProtocol {
    func formGeneratorCell(_ cell: FormGeneratorCell, updateValueFor string: String?)
    func formGeneratorCell(_ cell: FormGeneratorCell, updateValueFor int: Int?)
    func formGeneratorCellDidSelect(_ cell: FormGeneratorCell)
}

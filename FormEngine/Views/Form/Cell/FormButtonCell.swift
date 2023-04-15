//
//  FormButtonCell.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

class FormButtonCell: UITableViewCell, FormGeneratorCell {
    var button: UIButton!
    weak var delegate: FormGeneratorCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with data: FormGeneratorCellData) {
        button.setTitle(data.row.title, for: .normal)
    }

    @objc func handleSelect() {
        delegate?.formGeneratorCellDidSelect(self)
    }
}

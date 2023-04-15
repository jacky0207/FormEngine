//
//  FormView.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

open class FormView<V: UIView>: UIView {
    var titleLabel: UILabel!
    var contentView: V!
    var errorMessage: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        self.addSubview(titleLabel)

        contentView = V(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)

        errorMessage = UILabel(frame: .zero)
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        errorMessage.numberOfLines = 0
        errorMessage.textColor = .red
        self.addSubview(errorMessage)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),

            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),

            errorMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            errorMessage.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
            errorMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

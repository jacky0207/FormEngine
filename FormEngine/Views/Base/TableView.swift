//
//  TableView.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

class TableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delaysContentTouches = false  // remove dalays for touch-down gesture
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {  // remove touch delay for UIControl view like button
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

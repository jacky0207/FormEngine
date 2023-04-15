//
//  ViewController.swift
//  FormEngine
//
//  Created by Jacky Lam on 2023-04-11.
//

import UIKit

class ViewController: UIViewController {
    var formGeneratorView: FormGeneratorView!
    var form: Form = ModelData().form

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        formGeneratorView = FormGeneratorView(frame: .zero)
        formGeneratorView.translatesAutoresizingMaskIntoConstraints = false
        formGeneratorView.formDataSource = self
        formGeneratorView.formDelegate = self
        view.addSubview(formGeneratorView)  // for unknown row type
        NSLayoutConstraint.activate([
            formGeneratorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formGeneratorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formGeneratorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            formGeneratorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGestureRecognizer()
        addShowKeyboardObserver()
        formGeneratorView.reloadData()
    }

    // MARK: Keyboard
    private func addHideKeyboardGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false  // avoid breaking tableView(_:didSelectRowAt:)
        view.addGestureRecognizer(tapGesture)

        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeUpGesture.cancelsTouchesInView = false  // avoid breaking tableView(_:didSelectRowAt:)
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDownGesture.cancelsTouchesInView = false  // avoid breaking tableView(_:didSelectRowAt:)
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func addShowKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.keyboardFrame else {
            return
        }

        guard let activeField = UIResponder.activeField() else {
            return
        }

        guard let window = view.window else {
            return
        }

        // reset to original screen position y
        self.view.frame.origin.y = 0

        // adjust screen position y if keyboard will overlap field
        let activeFieldWindowRect = activeField.relativeRect(to: window)
        let bottomSpacing = window.frame.height - activeFieldWindowRect.bottom

        if keyboardFrame.height > bottomSpacing {
            self.view.frame.origin.y -= keyboardFrame.height - bottomSpacing
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

fileprivate extension NSNotification {
    var keyboardFrame: CGRect? {
        guard let userInfo = userInfo else {
            return nil
        }

        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }

        return keyboardSize.cgRectValue
    }
}

fileprivate extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }

    static func first() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    static func activeField() -> UIView? {
        return first() as? UIView
    }

    @objc private func _trap() {
        Static.responder = self
    }
}

fileprivate extension UIView {
    /// Return relative rect of self to view. If view is nil, return relative rect self to view
    func relativeRect(to view: UIView?) -> CGRect {
        return convert(bounds, to: view)
    }
}

fileprivate extension CGRect {
    var left: CGFloat {
        return origin.x
    }

    var top: CGFloat {
        return origin.y
    }

    var right: CGFloat {
        return origin.x + size.width
    }

    var bottom: CGFloat {
        return origin.y + size.height
    }
}

// MARK: - FormGeneratorViewDataSource
extension ViewController: FormGeneratorViewDataSource {
    func form(in view: FormGeneratorView) -> Form {
        return form
    }
}

// MARK: - FormGeneratorViewDelegate
extension ViewController: FormGeneratorViewDelegate {
    func formGeneratorView(_ view: FormGeneratorView, didSubmit values: [String: Any]) {
        print("values: \(values)")
    }
}

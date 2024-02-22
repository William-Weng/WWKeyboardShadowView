//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint
import WWKeyboardShadowView

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var keyboardShadowView: WWKeyboardShadowView!
    @IBOutlet weak var shadowViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - WWKeyboardShadowViewDelegate
extension ViewController: WWKeyboardShadowViewDelegate {
    
    func keyboardWillChange(view: WWKeyboardShadowView, information: WWKeyboardShadowView.KeyboardInfomation) -> Bool {
        wwPrint("keyboardWillChange")
        return true
    }
    
    func keyboardDidChange(view: WWKeyboardShadowView) {
        wwPrint("keyboardDidChange")
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        keyboardShadowView.configure(target: self, keyboardConstraintHeight: shadowViewHeightConstraint)
        keyboardShadowView.register()
    }
}

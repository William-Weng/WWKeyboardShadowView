//
//  WWKeyboardShadowView.swift
//  ChatGPTAPI
//
//  Created by William.Weng on 2024/2/21.
//

import UIKit

/// MARk: - WWKeyboardShadowViewDelegate
public protocol WWKeyboardShadowViewDelegate: AnyObject {
    
    func keyboardWillChange(view: WWKeyboardShadowView, information: WWKeyboardShadowView.KeyboardInfomation) -> Bool
    func keyboardDidChange(view: WWKeyboardShadowView)
}

/// MARk: - 開放函式
open class WWKeyboardShadowView: UIView {
    
    public typealias KeyboardInfomation = (duration: Double, curve: UInt, frame: CGRect)    // 取得系統鍵盤的相關資訊
    
    @IBOutlet weak var view: UIView!
    
    weak var target: (UIViewController & WWKeyboardShadowViewDelegate)?
    
    private weak var keyboardConstraintHeight: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    @objc func keyboardWillChange(_ notification: Notification) { keyboardNotification(notification) }
    
    deinit { unregister() }
}

/// MARk: - 開放函式
public extension WWKeyboardShadowView {
    
    /// 初始值設定
    /// - Parameters:
    ///   - target: UIViewController & WWKeyboardShadowViewDelegate>
    ///   - keyboardConstraintHeight: NSLayoutConstraint
    func configure(target: (UIViewController & WWKeyboardShadowViewDelegate)? = nil, keyboardConstraintHeight: NSLayoutConstraint) {
        self.keyboardConstraintHeight = keyboardConstraintHeight
        self.target = target
    }
    
    /// 註冊鍵盤事件
    func register() { keyboardNotification() }
    
    /// 解除鍵盤事件
    func unregister() { removeKeyboardNotification() }
}

/// MARk: - 小工具
private extension WWKeyboardShadowView {
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: Self.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        view.frame = bounds
        
        addSubview(view)
    }
    
    /// 鍵盤顯示 / 隱藏通知設定
    func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 移除通知設定
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}

/// MARk: - 高度設定
private extension WWKeyboardShadowView {
    
    /// 鍵盤事件通知處理
    /// - Parameter notification: Notification
    func keyboardNotification(_ notification: Notification) {
        
        guard let info = UIDevice._keyboardInformation(notification: notification),
              let curveType = UIView.AnimationCurve(rawValue: Int(info.curve)),
              let target = target
        else {
            return
        }
        
        let height = target.view.frame.height - info.frame.origin.y
        
        let isWillChange = target.keyboardWillChange(view: self, information: info)
        if (isWillChange) { updateHeightConstraint(height: height, duration: info.duration, curve: curveType) }
    }
    
    /// 更新高度
    /// - Parameters:
    ///   - height: CGFloat
    ///   - duration: Double
    ///   - curve: UIView.AnimationCurve
    func updateHeightConstraint(height: CGFloat, duration: Double, curve: UIView.AnimationCurve) {
        
        keyboardConstraintHeight?.constant = height
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            guard let this = self else { return }
            this.target?.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            guard let this = self else { return }
            this.target?.keyboardDidChange(view: this)
        }
        
        animator.startAnimation()
    }
}

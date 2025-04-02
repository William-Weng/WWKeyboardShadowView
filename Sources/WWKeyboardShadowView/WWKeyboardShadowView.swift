//
//  WWKeyboardShadowView.swift
//  WWKeyboardShadowView
//
//  Created by Willliam.Weng on 2025/4/2.
//

import UIKit

/// MARk: - 處理鍵盤高度的View
open class WWKeyboardShadowView: UIView {
        
    @IBOutlet weak var view: UIView!
    
    private weak var target: (UIViewController & WWKeyboardShadowView.Delegate)?
    private weak var keyboardConstraintHeight: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    @objc func keyboardChangeAction(_ notification: Notification) { keyboardNotification(notification) }
    
    deinit {
        target = nil
        unregister()
    }
}

/// MARk: - 開放函式
public extension WWKeyboardShadowView {
    
    /// 初始值設定
    /// - Parameters:
    ///   - target: UIViewController & WWKeyboardShadowView.Delegate>
    ///   - keyboardConstraintHeight: NSLayoutConstraint
    func configure(target: (UIViewController & WWKeyboardShadowView.Delegate)? = nil, keyboardConstraintHeight: NSLayoutConstraint?) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeAction), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeAction), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        guard let info = UIDevice._keyboardInfomation(notification: notification),
              let curveType = UIView.AnimationCurve(rawValue: Int(info.curve)),
              let target = target,
              let keyboardConstraintHeight = keyboardConstraintHeight
        else {
            target?.keyboardView(self, error: .notHeightConstraint); return
        }
        
        let height = target.view.frame.height - info.frame.origin.y
        
        var isWillChange: Bool = false
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification: isWillChange = target.keyboardViewChange(self, status: .willShow, information: info, height: height)
        case UIResponder.keyboardWillHideNotification: isWillChange = target.keyboardViewChange(self, status: .willHide, information: info, height: height)
        default: break
        }
        
        if (isWillChange) { updateHeightConstraint(height: height, info: info, curve: curveType) }
    }
    
    /// 更新高度
    /// - Parameters:
    ///   - height: CGFloat
    ///   - duration: Double
    ///   - curve: UIView.AnimationCurve
    func updateHeightConstraint(height: CGFloat, info: WWKeyboardShadowView.KeyboardInformation, curve: UIView.AnimationCurve) {
        
        guard let keyboardConstraintHeight = keyboardConstraintHeight else { return }
        
        keyboardConstraintHeight.constant = height
        
        let animator = UIViewPropertyAnimator(duration: info.duration, curve: curve) { [weak self] in
            guard let this = self else { return }
            this.target?.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            
            guard let this = self else { return }
            
            let displayStatus: DisplayStatus = (height != 0) ? .didShow : .didHide
            _ = this.target?.keyboardViewChange(this, status: displayStatus, information: info, height: height)
        }
        
        animator.startAnimation()
    }
}

//
//  Extension.swift
//  WWKeyboardShadowView
//
//  Created by Willliam.Weng on 2025/4/2.
//

import UIKit

// MARK: - UIDevice (function)
extension UIDevice {
    
    /// 取得鍵盤相關資訊
    /// - UIResponder.keyboardDidShowNotification / UIResponder.keyboardDidHideNotification
    /// - Parameter notification: 鍵盤的notification
    /// - Returns: Constant.KeyboardInfomation?
    static func _keyboardInfomation(notification: Notification) -> WWKeyboardShadowView.KeyboardInformation? {
        
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return nil
        }
        
        return (duration: duration, curve: curve, frame: frame)
    }
}

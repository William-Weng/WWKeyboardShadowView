//
//  Extension.swift
//  
//
//  Created by iOS on 2024/2/22.
//

import UIKit

// MARK: - UIDevice (function)
extension UIDevice {
    
    /// 取得鍵盤相關資訊
    /// - UIResponder.keyboardDidShowNotification / UIResponder.keyboardDidHideNotification
    /// - Parameter notification: 鍵盤的notification
    /// - Returns: Constant.KeyboardInfomation?
    static func _keyboardInformation(notification: Notification) -> WWKeyboardShadowView.KeyboardInfomation? {
        
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

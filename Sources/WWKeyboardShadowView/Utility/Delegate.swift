//
//  Delegate.swift
//  WWKeyboardShadowView
//
//  Created by Willliam.Weng on 2025/4/2.
//

import Foundation

/// MARk: - WWKeyboardShadowView.Delegate
public extension WWKeyboardShadowView {
        
    protocol Delegate: AnyObject {
        
        /// 鍵盤View的顯示狀態 / 可不可以改變
        /// - Parameters:
        ///   - view: WWKeyboardShadowView
        ///   - status: 鍵盤顯示狀態
        ///   - information: 鍵盤相關訊息
        ///   - height: 鍵盤的高度
        /// - Returns: Bool
        func keyboardViewChange(_ view: WWKeyboardShadowView, status: DisplayStatus, information: KeyboardInformation, height: CGFloat) -> Bool
        
        /// 錯誤提示
        /// - Parameters:
        ///   - view: WWKeyboardShadowView
        ///   - error: CustomError
        func keyboardView(_ view: WWKeyboardShadowView, error: CustomError)
    }
}

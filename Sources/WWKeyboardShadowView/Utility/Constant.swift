//
//  Constant.swift
//  WWKeyboardShadowView
//
//  Created by Willliam.Weng on 2025/4/2.
//

import UIKit

// MARK: - typealias
public extension WWKeyboardShadowView {
    
    typealias KeyboardInformation = (duration: Double, curve: UInt, frame: CGRect)    // 取得系統鍵盤的相關資訊
}

// MARK: - enum
public extension WWKeyboardShadowView {
    
    /// 顯示狀態
    enum DisplayStatus {
        case willShow
        case didShow
        case willHide
        case didHide
    }
    
    /// 自定義錯誤
    enum CustomError: Error {
        
        case notHeightConstraint
        
        /// 錯誤訊息
        /// - Returns: String
        func message() -> String {
            
            switch self {
            case .notHeightConstraint: return "高度Constraint尚未設定"
            }
        }
    }
}

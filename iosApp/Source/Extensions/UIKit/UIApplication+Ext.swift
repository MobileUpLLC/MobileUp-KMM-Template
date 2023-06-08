//
//  UIApplication+Ext.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

extension UIApplication {
    private static var safeAreaInsets: UIEdgeInsets?
    
    static func resignResponder() {
        Self.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    static func getSafeAreaInsets() -> UIEdgeInsets {
        if let safeAreaInsets {
            return safeAreaInsets
        }
        
        let safeAreaInsets = Self
            .shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets ?? .zero
        
        self.safeAreaInsets = safeAreaInsets
        
        return safeAreaInsets
    }
}

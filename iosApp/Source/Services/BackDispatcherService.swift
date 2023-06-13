//
//  BackDispatcherService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

class BackDispatcherService {
    static let shared = BackDispatcherService()
    
    let backDispatcher: BackDispatcher
    
    private init() {
        backDispatcher = BackDispatcherKt.BackDispatcher()
    }
}

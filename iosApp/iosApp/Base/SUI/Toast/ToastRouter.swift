//
//  ToastRouter.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

class ToastRouter: ObservableObject {
    /// Флаг, который определяет, показывается ли тост сейчас
    @Published var isShowing: Bool = false
    @Published var item: ToastItem?
    
    private var toastTask: Task<Void, Never>?
    
    @MainActor
    func showToast(item: ToastItem?, duration: TimeInterval? = 3.0) {
        guard let item else {
            return
        }
        
        // Отменяем текущий Task, если он есть
        toastTask?.cancel()
        toastTask = nil
        
        // Сначала скрываем текущий тост, если он показан
        if isShowing {
            isShowing = false
            
            // Делаем задержку перед показом нового тоста
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 секунды
                showNewToast(item: item, duration: duration)
            }
        } else {
            showNewToast(item: item, duration: duration)
        }
    }
    
    @MainActor
    func dismissToast() {
        dismiss()
    }
    
    @MainActor
    private func showNewToast(item: ToastItem, duration: TimeInterval?) {
        self.item = item
        isShowing = true
        
        if let duration {
            toastTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                await MainActor.run {
                    if item == self.item { // Чтоб не скрыть чужой тоаст
                        isShowing = false
                    }
                }
            }
        }
    }
    
    @MainActor
    private func dismiss() {
        isShowing = false
        item = nil
    }
}

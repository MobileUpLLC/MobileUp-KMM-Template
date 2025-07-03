//
//  SearchBarView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 09.06.2025.
//

import SwiftUI
import Combine

final class DebounceObject: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $text
            .debounce(for: .milliseconds(1_000), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard text.isEmpty == false else {
                    return
                }
                
                self?.debouncedText = text
            }
            .store(in: &cancellables)
    }
}

struct SearchBarView: View {
    typealias InputControl = shared.Kmm_form_validationInputControl
    let item: InputControl
    
    @Binding var isActive: Bool
    @StateObject private var debouncer = DebounceObject()
    @FocusState private var isFocused: Bool // Для отслеживания фокуса
    @State private var text: String = ""
    let placeholder: String = "Search text"
    
    init(item: InputControl, isActive: Binding<Bool>) {
        self.item = item
        self._isActive = isActive
    }
    
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                TextField(placeholder, text: $debouncer.text)
                    .lineLimit(1)
                    .focused($isFocused)
            }
            .onChange(of: debouncer.debouncedText) { newValue in
                item.onValueChange(value: newValue)
            }
            .onChange(of: isActive) { newValue in
                isFocused = newValue // Устанавливаем фокус, когда isActive меняется
            }
            .onChange(of: isFocused) { newValue in
                item.onFocusChange(hasFocus: newValue)
                isActive = newValue || !debouncer.text.isEmpty // Поле активно, если есть фокус или текст
            }
            
            if debouncer.text.isEmpty == false {
                Button {
                    debouncer.text = ""
                    withAnimation {
                        isActive = false
                        isFocused = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Capsule()
                .fill(.background)
                .overlay {
                    Capsule()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            SearchBarView(item: fakeInputControl(), isActive: .constant(true))
                .padding()
        }
        .background(.black.opacity(0.1))
    }
}

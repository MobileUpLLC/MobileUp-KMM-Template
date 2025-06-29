//
//  MessageView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

struct MessageView: View {
    let message: Message?
    let onActionClick: Closure.Void
    
    var body: some View {
        if let message {
            HStack(spacing: .zero) {
                Image(systemName: "info.square")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.trailing, .eight)
                
                Text(message.text.localized())
                    .foregroundColor(.white)
                    .font(.caption)
                
                if let actionTitle = message.actionTitle?.localized() {
                    Spacer(minLength: 16)
                    
                    Button(actionTitle, action: onActionClick)
                        .foregroundColor(.green)
                        .font(.body.bold())
                } else {
                    Spacer()
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 24)
            .padding(.vertical, .eight)
            .background(.black)
            .cornerRadius(.eight)
        }
    }
}

#Preview {
    MessageView(
        message: Message(
            text: MR.strings().error_no_internet_connection.desc(),
            actionTitle: MR.strings().common_finish.desc()
        ),
        onActionClick: {}
    )
}

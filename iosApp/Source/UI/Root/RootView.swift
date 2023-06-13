import SwiftUI
import Combine

struct RootView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    @ObservedObject private var message: NullableObservableState<Message>
    
    private let component: RootComponent
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
        self.message = NullableObservableState(component.messageComponent.visibleMessage)
    }
    
    var body: some View {
        ZStack {
            ViewsContainer(items: childStack.value.items)
            
            VStack(spacing: .zero) {
                MessageView(
                    message: message.value,
                    onActionClick: { component.messageComponent.onActionClick() }
                )
                .padding(.horizontal, 16)
                .padding(.top, UIApplication.getSafeAreaInsets().top + .eight)
                .hidden(message.value == nil)
                .animation(.easeIn(duration: 0.3), value: message.value)
                .transition(.move(edge: .top))
                
                Spacer()
            }
            .zIndex(Double(childStack.value.items.count))
        }
        .ignoresSafeArea()
        .animation(.default, value: childStack.value.items.last)
        .transition(.opacity)
    }
}

private struct ViewsContainer: View {
    let items: [Child<AnyObject, RootComponentChild>]
    
    var body: some View {
        ForEach(.zero..<items.count, id: \.self) { index in
            ChildView(
                child: items[index].instance
            )
            // To prevent views disappear transition not animated
            // https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/#solution
            .zIndex(Double(index))
        }
    }
}

private struct ChildView: View {
    let child: RootComponentChild?
    
    var body: some View {
        switch child {
        case let flowOne as RootComponentChild.Flow1:
            FlowOneView(component: flowOne.component)
        case let flowTwo as RootComponentChild.Flow2:
            FlowTwoView(component: flowTwo.component)
        case let home as RootComponentChild.Home:
            HomeView(component: home.component)
        default:
            EmptyView()
        }
    }
}

private struct MessageView: View {
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent())
        
        MessageView(
            message: Message(
                text: MR.strings().error_no_internet_connection.desc(),
                actionTitle: MR.strings().common_finish.desc()
            ),
            onActionClick: {}
        )
        .previewDisplayName("MessageView")
    }
}

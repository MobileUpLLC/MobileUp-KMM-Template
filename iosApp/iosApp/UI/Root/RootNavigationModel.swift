//
//  RootNavigationModel.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI
import Combine

protocol ObservableNavigation: ObservableObject {
    var navigationPath: NavigationPath { get set }
    var flatPath: [AnyHashable] { get set }
    
    func syncPath<Destination: AnyObject & Hashable>(state: NavigationState, type: Destination.Type)
}

class RootNavigationModel: ObservableNavigation {
    @Published var navigationPath: NavigationPath = .init()
    @Published var flatPath: [AnyHashable] = []
    @Published var tabComponent: AnyHashable?
    var showHome: Bool { flatPath.last?.description.contains("Home") ?? false }
    
    private var cancellables: Set<AnyCancellable> = []
    private let navigationSubject = PassthroughSubject<(NavigationState, any Hashable.Type), Never>()
    
    init(path: NavigationPath = NavigationPath(), pathProxy: [AnyHashable] = []) {
        self.navigationPath = path
        self.flatPath = pathProxy
        
        syncNavigationInput()
        sinkNavigationOutput()
    }
    
    func syncPath<Destination: AnyObject & Hashable>(state: NavigationState, type: Destination.Type) {
        switch state {
        case .root(let root):
            let isPushToTab = root.description.contains("Home")
            if isPushToTab {
                tabComponent = root
            }
            flatPath = [root]
            navigationSubject.send((state, type))
        case .push(let destination):
            let isPushToTab = destination.description.contains("Home")
            if isPushToTab {
                tabComponent = destination
            }
            flatPath.append(destination)
            if isPushToTab == false {
                navigationSubject.send((state, type))
            }
        case .pop:
            if showHome {
                flatPath.removeLast()
            } else {
                flatPath.removeLast()
                navigationSubject.send((state, type))
            }
        case .popToRoot:
            break
        case .replace(let stack):
            flatPath = stack
            navigationSubject.send((state, type))
        case .empty:
            break
        }
    }

    private func syncNavigationInput() {
        navigationSubject
            .sink { [weak self] state, type in
                guard let self else {
                    return
                }
                
                switch state {
                case .push(let item):
                    guard let destination = item.cast(to: type) else {
                        return
                    }
                    
                    navigationPath.append(destination)
                case .pop:
                    navigationPath.removeLast()
                case .root:
                    navigationPath.removeAll()
                default:
                    print("NavigationState not handled")
                }
            }
            .store(in: &cancellables)
    }
    
    private func sinkNavigationOutput() {
        $navigationPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self else {
                    return
                }
                
                let state = newValue.getState(fromPath: flatPath)
                switch state {
                case .push:
                    break // Уже добавлено ранее в KMM
                case .pop:
                    flatPath.removeLast() // Пользователь нажал назад
                    BackDispatcherService.shared.backDispatcher.back() // Отправляем событие в KMM
                case .popToRoot:
                    flatPath = flatPath.suffix(1) // Вернулись к исходному компоненту
                    BackDispatcherService.shared.backDispatcher.back() // Нет функции пока такой
                case .empty:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

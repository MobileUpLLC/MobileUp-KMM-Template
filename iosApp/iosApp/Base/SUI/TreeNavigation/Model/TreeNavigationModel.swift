//
//  TreeNavigationModel.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI
import Combine

/// Модель навигации, синхронизирующая KMM-навигацию с SwiftUI `NavigationStack`.
///
/// `TreeNavigationModel` реализует двухстороннюю синхронизацию между KMM (Kotlin Multiplatform)
/// и SwiftUI с использованием дублирующего стека `flatPath`, отражающего актуальное состояние пути.
///
/// Навигация из KMM поступает через метод `syncPath`, где обновляется `flatPath`, а затем —
/// публикуется новое состояние в `navigationSubject`, на которое подписан `navigationPath`.
///
/// В случае навигации из SwiftUI (например, кнопка «Назад»), изменения перехватываются через
/// подписку на `$navigationPath`, где анализируется текущее состояние относительно `flatPath`,
/// и при необходимости отправляется обратный сигнал в KMM.
///
/// Важным элементом архитектуры является свойство `tabComponent`, которое отвечает за извлечение
/// компонента активной вкладки в навигации. Это необходимо для правильного отображения контента в
/// случае, если пользователь находится на вкладке, которая не может быть непосредственно вложена
/// в `NavigationStack` в SwiftUI (например, в случае с `TabView`).
class TreeNavigationModel: ObservableNavigation {
    /// Основной стек навигации SwiftUI.
    @Published var navigationPath: NavigationPath = .init()
    
    /// Линейное (плоское) представление пути из KMM.
    ///
    /// Хранит упрощённый стек экранов, используется для вычисления состояния и
    /// синхронизации с `NavigationPath`.
    @Published var flatPath: [AnyHashable] = []
    
    /// Активный компонент вкладки.
    ///
    /// Это свойство используется для извлечения компонента для экрана TabView,
    /// Если текущая экран отображает TabView экран,
    /// то компонент будет предназначен для неё, и навигация будет синхронизирована.
    @Published var tabComponent: AnyHashable?
    
    /// Возвращает `true`, если текущий путь соответствует экрану с TabView.
    var showHome: Bool { flatPath.last?.description.contains(tabDescription) ?? false }
    
    private var cancellables: Set<AnyCancellable> = []
    
    /// Субъект для передачи событий навигации из KMM в SwiftUI.
    private let navigationSubject = PassthroughSubject<(NavigationState, any Hashable.Type), Never>()
    
    /// Строковое описание вкладки, к которой относится модель.
    ///
    /// Этот параметр используется для извлечения вкладки в `TabView` и синхронизации
    /// с навигацией в случае, если в неё осуществлен переход.
    private let tabDescription: String
    
    /// Инициализирует модель навигации.
    ///
    /// Обычно не нужно задавать начальные значения.
    ///
    /// - Attention: Для deep link инициализация еще не тестирвалась.
    ///
    /// - Parameters:
    ///   - path: Начальный `NavigationPath`.
    ///   - pathProxy: Начальный `flatPath` (из KMM).
    ///   - tabDescription: Название вкладки, по которому производится фильтрация пути для извлечения TabView
    init(path: NavigationPath = NavigationPath(), pathProxy: [AnyHashable] = [], tabDescription: String = "Home") {
        self.navigationPath = path
        self.flatPath = pathProxy
        self.tabDescription = tabDescription
        
        syncNavigationInput()
        sinkNavigationOutput()
    }
    
    /// Обрабатывает входящее событие навигации от KMM.
    ///
    /// Изменяет `flatPath` и отправляет сигнал в `navigationSubject` для обновления `navigationPath`.
    ///
    /// - Parameters:
    ///   - state: Состояние навигации (`push`, `pop`, `replace` и т.д.).
    ///   - type: Тип экрана, необходимый для безопасного каста.
    func syncPath<Destination: AnyObject & Hashable>(state: NavigationState, type: Destination.Type) {
        switch state {
        case .root(let root):
            let isPushToTab = root.description.contains(tabDescription)
            if isPushToTab {
                tabComponent = root
            }
            flatPath = [root]
            navigationSubject.send((state, type))
        case .push(let destination):
            let isPushToTab = destination.description.contains(tabDescription)
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

    /// Подписка на входящий поток навигации (KMM → SwiftUI).
    ///
    /// Обновляет `navigationPath` на основе `navigationSubject`, выполняя нужные действия
    /// (`append`, `removeLast`, `removeAll`) в зависимости от состояния.
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
    
    /// Отслеживает изменения `navigationPath` (SwiftUI → KMM).
    ///
    /// Сравнивает с `flatPath`, определяет тип действия (`pop`, `popToRoot`) и отправляет сигнал обратно в KMM.
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

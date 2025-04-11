# KMM iOS MobileUp Template

Шаблон iOS приложения реализованного на KMM архитектуре

## Описание

Этот проект представляет собой архитектуру iOS приложения (от iOS 16.1), написанного на фреймворке SwiftUI, реализованную с KMM (Kotlin Multiplatform Mobile). Он обеспечивает работу с навигацией через несколько стеков, синхронизацию с компонентами, поддерживает работу с KMM (Kotlin Multiplatform Mobile) и взаимодействие с компонентами через декларативный UI.

## Основные компоненты

1. **NavigationState**: Enum, описывающий различные состояния навигации (например, переходы между экранами, назад, к корню и т. д.).
2. **TreeNavigationModel**: Модель для управления состоянием навигации, которая синхронизирует данные между SwiftUI и KMM.
3. **TreeNavigation**: Протокол и расширения для реализации навигации с использованием стека компонентов.
4. **RootHolder**: Контейнер для корневого компонента приложения, управляет конфигурацией и зависимостями.
5. **BackDispatcherService**: Сервис для обработки навигации "назад" с использованием KMM.
6. **BottomSheetChild**: Модификатор для поднятия окон через свойство в компоненте состояния из KMM.
6. **AlertChild**: Модификатор для отображения модальных окон через свойство в компоненте состояния из KMM.
7. **RootTreeNavigation**: Модификатор для инициализации и работы с корневым компонентом и навигацией через `TreeNavigation`.

## Установка

Для использования этого проекта в вашем приложении, выполните следующие шаги:

1. Клонируйте репозиторий [MobileUp-KMM-Template](https://github.com/MobileUpLLC/MobileUp-KMM-Template.git)
2. Установить [Android Studio](https://developer.android.com/studio?hl=ru)
3. Установить [Java](https://www.java.com/ru/)
4. Установить [Java JDK 21](https://www.oracle.com/java/technologies/downloads/#jdk21-mac)
5. Запустить Android Studio и дождаться окончания загрузки импорта проекта (снизу справа панель)
6. Установить плагин "Kotlin Multiplatform" из Android Studio -> Settings -> Plugins
7. Перезапустить Android Studio
8. Запустить Xcode по файлу проекта шаблона

## Архитектура

- **Shared**: модуль совместного кода, который может быть использован как на Android, так и на iOS.
- **Модели навигации**: Используется паттерн "Tree Navigation", где каждое состояние навигации управляется через модель и синхронизируется между KMM и SwiftUI.
- **RootHolder**: Класс `RootHolder` используется для хранения и инициализации корневого компонента приложения. Он управляет настройками и контекстом компонента, который используется в приложении. Этот класс инициализирует все зависимости, включая конфигурацию и жизненный цикл компонента, и предоставляет доступ к корневому компоненту.
- **BackDispatcherService**: Сервис для управления возвращением назад, включая взаимодействие с KMM.
- **Декларативная навигация**: Взаимодействие с экранами и состоянием происходит декларативно через протоколы и модификаторы SwiftUI.
- **ObservableState** и **ObservableOptionalState**: Используется, когда необходимо получать обновления из KMM-кода и автоматически обновлять SwiftUI-интерфейс. `ObservableState` наблюдает за Kotlin Multiplatform `StateFlow` и предоставляет его данные в SwiftUI через свойство `@Published`.

## shared
В Kotlin Multiplatform Mobile (KMM) используется концепция shared для совместного кода, который может быть использован как на Android, так и на iOS. Этот код хранится в shared модуле, который содержит общую логику приложения (например, бизнес-логику, доступ к данным, сетевые запросы и другие функции), которые могут быть использованы в обоих мобильных приложениях.

Описание модуля shared:

- Что лежит в shared: Все общие компоненты, такие как бизнес-логика, модели данных, сетевые запросы и т. д.
- Как это работает: Код из модуля shared компилируется и используется как для Android-приложения, так и для iOS-приложения. Для взаимодействия с нативными компонентами (например, UI, платформенно-зависимыми фичами) используются специальным образом настроенные интерфейсы и соответствующие зависимости.
- Kotlin/Native: Для iOS используется Kotlin/Native, который позволяет компилировать Kotlin-код в нативные библиотеки, которые можно использовать в iOS-приложении.
- Обмен данными: Для обмена данными между платформами (например, для передачи состояния навигации) в shared часто используются механизмы, такие как StateFlow (SkieSwiftStateFlow/SkieSwiftOptionalStateFlow) для асинхронного взаимодействия.

## Пример использования

### Точка входа

```swift
@main
struct iosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var rootHolder = RootHolder()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rootHolder) // Передаем RootHolder в окружение
        }
    }
}
```

### Настройка навигации с TreeNavigation

```swift
struct RootView: View, TreeNavigation {
    @StateObject var navigationModel = TreeNavigationModel()
    @ObservedObject var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            rootView
                .treeNavigation(childStack: childStack, navigationModel: navigationModel, destination: destination(for:))
        }
        .setRootTreeNavigation(childStack: childStack, navigationModel: navigationModel) // Ставим в стек корневое представление
        .environmentObject(navigationModel) // Передаем TreeNavigationModel в окружение
    }

    func destination(for item: RootComponentChild) -> some View {
        switch onEnum(of: item) {
        case .flow1(let child):
            FlowOneView(component: child.component)
        case .flow2(let child):
            FlowTwoView(component: child.component)
        case .flow3(let child):
            FlowThreeView(component: child.component)
        }
    }
}
```

### Навигация и управление стеком с использованием KMM

Модель навигации, синхронизирующая KMM-навигацию с SwiftUI `NavigationStack`. `TreeNavigationModel` реализует двухстороннюю синхронизацию между KMM (Kotlin Multiplatform) и SwiftUI с использованием дублирующего стека `flatPath`, отражающего актуальное состояние пути. Навигация из KMM поступает через метод `syncPath`, где обновляется `flatPath`, а затем — публикуется новое состояние в `navigationSubject`, на которое подписан `navigationPath`. В случае навигации из SwiftUI (например, кнопка «Назад»), изменения перехватываются через подписку на `$navigationPath`, где анализируется текущее состояние относительно `flatPath`, и при необходимости отправляется обратный сигнал в KMM. Важным элементом архитектуры является свойство `tabComponent`, которое отвечает за извлечение компонента активной вкладки в навигации. Это необходимо для правильного отображения контента в случае, если пользователь находится на вкладке, которая не может быть непосредственно вложена в `NavigationStack` в SwiftUI (например, в случае с `TabView`).

```swift
class TreeNavigationModel: ObservableNavigation {
    @Published var navigationPath: NavigationPath = .init()
    @Published var flatPath: [AnyHashable] = []
    
    func syncPath<Destination: AnyObject & Hashable>(state: NavigationState, type: Destination.Type) {
        // Логика синхронизации пути навигации
    }
}
```

### Обновления состояний
Обёртка над `SkieSwiftStateFlow`, предназначенная для интеграции с SwiftUI. `ObservableState` наблюдает за Kotlin Multiplatform `StateFlow` и предоставляет его данные в SwiftUI через свойство `@Published`.

Используется, когда необходимо получать обновления из KMM-кода и автоматически обновлять SwiftUI-интерфейс.
> Примечание: Подписка осуществляется асинхронно, обновления происходят на главном потоке..

### Использование BottomSheetChild

```swift
struct ContentView: View {
    @StateObject var dialogControl = DialogControl<YourType, YourDestination>()
    
    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                dialogControl.show()
            }
        }
        .bottomSheet(childSlot: dialogControl.childSlot, dialogControl: dialogControl) {
            Text("This is a bottom sheet!")
        }
    }
}
```

## Примечания

- **TabView**: Важно помнить, что TabView не может быть вложен в `NavigationStack`, для этого используется специальный механизм извлечения и управления компонентами с помощью `tabDescription`.

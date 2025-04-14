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
6. **BottomSheetChild**: Модификатор для поднятия окон через свойство в компоненте из KMM.
6. **AlertChild**: Модификатор для отображения модальных окон через свойство в компоненте из KMM.
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
Shared модуль в KMM — это основа всей идеи мультиплатформенной разработки: это место, где пишется единый код, который потом можно использовать на обеих платформах — Android и iOS.

В Kotlin Multiplatform Mobile (KMM) используется концепция shared для совместного кода, который может быть использован как на Android, так и на iOS. Этот код хранится в shared модуле, который содержит общую логику приложения (например, бизнес-логику, доступ к данным, сетевые запросы и другие функции), которые могут быть использованы в обоих мобильных приложениях.

**Что лежит внутри shared?**

В этом модуле обычно сосредоточен платформенно-независимый код:

- Бизнес-логика
- Модели данных
- Работа с сетью
- Доступ к данным
- Асинхронность и реактивность: StateFlow (SkieSwiftStateFlow/SkieSwiftOptionalStateFlow)
- Интерфейсы для платформенной реализации: если что-то нельзя сделать в общем коде, описывается интерфейс с реализациями под Android/iOS

**Как это работает?**

На iOS:

- Через Kotlin/Native shared-код компилируется в .framework (import shared), которую можно использовать в Xcode
- Kotlin-классы и функции становятся доступными в Swift с помощью мостов (Objective-C объекты в shared)
- Skie библиотека, которая генерирует объекты в Swift код (например перечисления)

**Обмен данными: как делиться состоянием?**

Для реактивного взаимодействия между слоями часто используются:

- StateFlow — для управления состоянием и подписки на его изменения.
- Обёртки для Swift (SkieSwiftStateFlow, SkieSwiftOptionalStateFlow) — упрощают работу с Kotlin-стримами на стороне iOS.
- Kotlinx.coroutines — для асинхронной логики.

## Наблюдатели KotlinStateFlow / KotlinOptionalStateFlow
SwiftUI-обёртки над StateFlow из Kotlin Multiplatform (через Skie), позволяющие удобно наблюдать за потоками состояний прямо в SwiftUI-компонентах.

> Используйте @KotlinStateFlow для потоков с неопциональными значениями, и @KotlinOptionalStateFlow — если значения могут быть nil.

**Возможности**
- Автоматически обновляют SwiftUI UI при изменении значений в Kotlin StateFlow
- Выполняют подписку на главном потоке
- Совместимы с @StateObject и @ObservedObject

**Как использовать**
```swift
struct HelloView: View {
    private let component: HelloComponent

    @StateObject @KotlinStateFlow private var text: String

    init(component: HelloComponent) {
        self.component = component
        self._text = .init(component.text)
    }

    var body: some View {
        Text(text)
            .font(.title)
            .padding()
    }
}
```

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

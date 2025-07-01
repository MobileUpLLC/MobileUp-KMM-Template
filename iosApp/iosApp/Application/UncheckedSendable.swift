//
//  UncheckedSendable.swift
//  iosApp
//
//  Created by Denis Dmitriev on 06.05.2025.
//
/*
Этот файл содержит расширения для пометки типов, генерируемых Skie из Kotlin Multiplatform,
как `@unchecked Sendable` для соответствия требованиям Swift 6 по потокобезопасности.
 
Использование `@unchecked Sendable` необходимо, так как Skie (версия 0.10.1) на момент мая 2025 года
не предоставляет встроенной поддержки протокола `Sendable` для генерируемых типов,
таких как `ChildStack`, `LoadableState` и `Message`.
Эти типы представляют данные из Kotlin `StateFlow`, который разработан для конкурентного доступа и,
вероятно, безопасен, но компилятор Swift 6 требует явного соответствия `Sendable`.
 
Это временное решение, действующее до:
1. Выхода обновления Skie с поддержкой `Sendable` для генерируемых типов.
2. Подтверждения потокобезопасности типов путём анализа исходного кода Skie или Kotlin.
 
Рекомендуется:
 - Следить за обновлениями Skie: https://skie.touchlab.co/category/changelog
 - Проверять потокобезопасность типов: https://skie.touchlab.co/features/flows
 - Ознакомиться с руководством по конкурентности Swift 6:
    https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/dataracesafety
*/

import Foundation

extension ChildStack: @unchecked @retroactive Sendable {}
extension LoadableState: @unchecked @retroactive Sendable {}
extension PagedState: @unchecked @retroactive Sendable {}
extension Message: @unchecked @retroactive Sendable {}
extension ChildSlot: @unchecked @retroactive Sendable {}
extension NSArray: @unchecked @retroactive Sendable {}
extension PokemonType: @unchecked @retroactive Sendable {}
extension PokemonTypeId: @unchecked @retroactive Sendable {}

//
//  Kotlinx_datetimeLocalTime+Date.swift
//  iosApp
//
//  Created by Denis Dmitriev on 15.05.2025.
//

import Foundation

extension LocalDateTime {
    func toDate(in timeZone: Foundation.TimeZone = .current) -> Date? {
        var components = DateComponents()
        components.year = Int(self.year)
        components.month = Int(self.monthNumber)
        components.day = Int(self.dayOfMonth)
        components.hour = Int(self.hour)
        components.minute = Int(self.minute)
        components.second = Int(self.second)
        components.nanosecond = Int(self.nanosecond)
        components.timeZone = timeZone
        
        // Используем текущий календарь для создания Date
        let calendar = Calendar.current
        return calendar.date(from: components)
    }
    
    @MainActor static let mockDate: LocalDateTime = {
        LocalDateTime(
            date: .init(year: 2025, month: .april, dayOfMonth: 12),
            time: .init(hour: 12, minute: 00, second: 00, nanosecond: 0)
        )
    }()
}

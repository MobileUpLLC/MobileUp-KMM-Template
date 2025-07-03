//
//  Data+KotlinByteArray.swift
//  iosApp
//
//  Created by Denis Dmitriev on 24.06.2025.
//

import Foundation

extension KotlinByteArray {
    func toData() -> Data {
        // Получаем размер массива
        let size = Int(self.size)
        // Создаем буфер для байтов
        var bytes = [Int8](repeating: 0, count: size)
        // Заполняем буфер значениями из KotlinByteArray
        for index in 0..<size {
            bytes[index] = self.get(index: Int32(index))
        }
        // Преобразуем массив Int8 в Data
        return Data(bytes.map { UInt8(bitPattern: $0) })
    }
}

extension Data {
    init(kmm: KotlinByteArray) {
        self = kmm.toData()
    }
    
    func toKotlinByteArray() -> KotlinByteArray {
        let kotlinArray = KotlinByteArray(size: Int32(self.count))
        self.withUnsafeBytes { buffer in
            for (index, byte) in buffer.enumerated() {
                kotlinArray.set(index: Int32(index), value: Int8(bitPattern: byte))
            }
        }
        return kotlinArray
    }
}

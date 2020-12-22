//
//  RandomAccessCollection.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import Foundation


extension RandomAccessCollection where Element : StringProtocol {
    
    /// Возвращает индекс элемента в отсортированном массиве строк. Не чувствительно к регистру. Модифицировал идею, взатую отсюда: [https://stackoverflow.com/a/55395494/13433324](https://stackoverflow.com/a/55395494/13433324)
    func insertionIndex(of value: Element) -> Index {
        var slice : SubSequence = self[...]

        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if value.lowercased() < slice[middle].lowercased() {
                slice = slice[..<middle]
            } else {
                slice = slice[index(after: middle)...]
            }
        }
        return slice.startIndex
    }
    
}

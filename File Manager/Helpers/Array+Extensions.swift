//
//  Array+Extensions.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import Foundation

extension Array where Element: StringProtocol {
    
    /// Вставляет элемент в заранее упорядоченный массив строк. Без чувствительности к регистру. Модифицировал идею, взатую отсюда: [https://stackoverflow.com/a/55395494/13433324](https://stackoverflow.com/a/55395494/13433324)
    /// - Parameter item: Элемент типа String.
    mutating func appendSorted(_ item: Element) {
        var slice : SubSequence = self[...]
                while !slice.isEmpty {
                    let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
                    if item.lowercased() < slice[middle].lowercased() {
                        slice = slice[..<middle]
                    } else {
                        slice = slice[index(after: middle)...]
                    }
                }
        self.insert(item, at: slice.startIndex)
    }
    
}

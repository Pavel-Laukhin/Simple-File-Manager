//
//  FileManagerService.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import Foundation

protocol FileManagerServiceProtocol {
    
    /// Метод возвращает список файлов и папок в указанной директории.
    func getContent(for directory: String) -> [String]?
    
    /// Возвращает true в случае удачи и false в случае неудачи.
    func addNewFolder(namedAs name: String, to directory: String) -> String?
    
    /// Возвращает true в случае удачи и false в случае неудачи.
    func addNewFile(namedAs name: String, containing: String, toDirectory directory: String) -> String?
    
    /// Читает содержимое файла и возвращает текст, записанный внутри.
    func readFile(withName name: String, from directory: String) -> String?
    
    /// Удаляет файл или папку.
    func deleteItem(withName: String, inDirectory: String)
    
    /// Возвращает URL файла или папки. Возвращает nil, если такого файла/папки не существует.
    func urlForItemNamed(as: String, inDirectory: String) -> URL?
    
}

struct FileManagerService: FileManagerServiceProtocol {
    
    func getContent(for directory: String) -> [String]? {
        guard let directoryPath = getURL(for: directory)?.path,
              let directory = try? FileManager.default.contentsOfDirectory(atPath: directoryPath)else {
            assertionFailure("Can't make path or get a content")
            return nil
        }
        print("directoryPath: \(directoryPath)")
        return directory
    }
    
    func addNewFolder(namedAs name: String, to directory: String) -> String? {
        guard let url = getURL(for: directory + "/" + name) else {
            assertionFailure("Can't create directory path!")
            return nil
        }
        let nameAndUrl = defineNameAndURL(forURL: url, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: nameAndUrl.url, withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            assertionFailure("Can't create directory! Error: \(error.localizedDescription)")
            return nil
        }
        return nameAndUrl.name
    }
    
    func addNewFile(namedAs name: String, containing text: String, toDirectory directory: String) -> String? {
        guard let url = getURL(for: directory + "/" + name) else {
            assertionFailure("Can't create file path!")
            return nil
        }
        let nameAndUrl = defineNameAndURL(forURL: url, isDirectory: false)
        let filePath = nameAndUrl.url.path
        let rawData: Data? = text.data(using: .utf8)
        if FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil) {
            return nameAndUrl.name
        } else {
            assertionFailure("Can't create file!")
            return nil
        }
    }
    
    func readFile(withName name: String, from directory: String) -> String? {
        guard var filePath = getURL(for: directory)?.path else {
            assertionFailure("Can't create directory path!")
            return nil
        }
        filePath += "/" + name
        guard let fileContent = FileManager.default.contents(atPath: filePath),
              let fileContentEncoded = String(bytes: fileContent, encoding: .utf8) else {
            assertionFailure("Can't get file content or encode it to String!")
            return nil
        }
        return fileContentEncoded
    }
    
    func deleteItem(withName name: String, inDirectory directory: String) {
        guard let itemURL = getURL(for: directory)?.appendingPathComponent(name) else {
            assertionFailure("\(type(of: self)) \(#function) Can't create file path!")
            return
        }
        do {
            try FileManager.default.removeItem(at: itemURL)
        } catch {
            assertionFailure("Can't remove item!")
        }
    }
    
    func urlForItemNamed(as name: String, inDirectory dir: String) -> URL? {
        let fullName: String
        if dir == "Documents" {
            fullName = name
        } else {
            guard let startIndex = dir.firstIndex(of: "/") else {
                assertionFailure("Unknown folder!")
                return nil
            }
            fullName = dir[startIndex...] + "/" + name
        }
        guard let itemURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fullName) else {
            assertionFailure("Can't make URL!")
            return nil
        }
        if FileManager.default.fileExists(atPath: "\(itemURL.path)"){
            return itemURL
        } else {
            assertionFailure("There is no item with name: \(name)")
            return nil
        }
    }
    
    //MARK: - Private
    private func getURL(for directory: String) -> URL? {
        switch directory {
        case "Documents":
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                assertionFailure("Can't make URL!")
                return nil
            }
            return documents
        default:
            let initialPath = "file://" + NSHomeDirectory()
            guard let url = URL(string: initialPath)?.appendingPathComponent(directory) else {
                assertionFailure("Can't make URL!")
                return nil
            }
            return url
        }
    }
    
    /// Если объект с таким именем существует, то метод переименовывает задублированный объект. Добавляет к имени индекс до тех пор, пока новое имя не станет уникальным.
    /// - Returns: Возвращает точно такое же имя, но с суффиксом в виде индекса в круглых скобках.
    private func defineNameAndURL(forURL url: URL, isDirectory: Bool) -> (name: String, url: URL) {
        var itemPath = url.path
        var newIndex = 0
        var newName = url.lastPathComponent
        var newUrl = url
        while FileManager.default.fileExists(atPath: "\(itemPath)") {
            let nameAndIndex = getNameAndIndex(from: newName)
            newIndex = nameAndIndex.index ?? 0
            newIndex += 1
            newName = nameAndIndex.name + "(" + String(newIndex) + ")"
            itemPath = newUrl.deletingLastPathComponent().path + "/" + newName
            newUrl.deleteLastPathComponent()
            newUrl.appendPathComponent(newName, isDirectory: isDirectory)
        }
        return (newName, newUrl)
    }
    
    /// Возвращает кортеж, состоящий из имени и его индекса, если у имени был в конце числовой индекс в круглых скобках.
    private func getNameAndIndex(from name: String) -> (name: String, index: Int?) {
        if let last = name.reversed().first, last == ")",
           let indexOfOpenBracket = name.reversed().firstIndex(of: "(") {
            let nameWithoutIndex = String(name.reversed()[indexOfOpenBracket...].reversed().dropLast())
            let stringBetweenBrackets = String(name.reversed()[...indexOfOpenBracket].reversed())
                .dropFirst()
                .dropLast()
            let index = Int(stringBetweenBrackets)
            return (nameWithoutIndex, index)
        } else {
            return (name, nil)
        }
    }
    
}

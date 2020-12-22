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
    
    /// Добавляет папку. Возвращает true в случае удачи и false в случае неудачи.
    func addFolderNamed(as name: String, to directory: String) -> Bool
    
    /// Добавляет файл. Возвращает true в случае удачи и false в случае неудачи.
    func addFile(containing: String, toDirectory directory: String, withName name: String) -> Bool
    
    /// Удаляет файл или папку.
    func delete(at path: String, withName name: String)
    
}

struct FileManagerService: FileManagerServiceProtocol {
    
    func getContent(for directory: String) -> [String]? {
        guard let directoryPath = getURL(for: directory)?.path,
              let directory = try? FileManager.default.contentsOfDirectory(atPath: directoryPath)else {
            assertionFailure("\(#function) Can't make path or get a content")
            return nil
        }
        print("directoryPath: \(directoryPath)")
        return directory
    }
    
    func addFolderNamed(as name: String, to directory: String) -> Bool {
        guard let _ = getURL(for: directory + "/" + name)?.path else {
            assertionFailure("\(#function) Can't create directory path!")
            return false
        }
        return true
    }
    
    func addFile(containing: String, toDirectory directory: String, withName name: String) -> Bool {
        guard var filePath = getURL(for: directory)?.path else {
            assertionFailure("\(#function) Can't create directory path!")
            return false
        }
        filePath += "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        if FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil) {
            return true
        } else {
            assertionFailure("\(#function) Can't create file!")
            return false
        }
    }
    
    func readFile(from directory: String, withName name: String) -> String? {
        guard var filePath = getURL(for: directory)?.path else {
            assertionFailure("\(#function) Can't create directory path!")
            return nil
        }
        filePath += "/" + name
        guard let fileContent = FileManager.default.contents(atPath: filePath),
              let fileContentEncoded = String(bytes: fileContent, encoding: .utf8) else {
            assertionFailure("\(#function) Can't get file content or encode it to String!")
            return nil
        }
        return fileContentEncoded
    }
    
    func delete(at path: String, withName name: String) {
        guard let filePath = getURL(for: path)?.appendingPathComponent(name) else {
            assertionFailure("\(#function) Can't create file path!")
            return
        }
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            assertionFailure("\(#function) Can't remove item!")
        }
    }
    
    private func getURL(for directory: String) -> URL? {
        switch directory {
        case "Documents":
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                assertionFailure("\(#function) Can't make URL!")
                return nil
            }
            return documents
        default:
            let initialPath = "file://" + NSHomeDirectory() //+ urlDirectory
            guard let url = URL(string: initialPath)?.appendingPathComponent(directory) else {
                assertionFailure("\(#function) Can't make URL!")
                return nil
            }
            if !FileManager.default.fileExists(atPath: "\(url)") {
                try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            }
            return url
        }
    }
    
}

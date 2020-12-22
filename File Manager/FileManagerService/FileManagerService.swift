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
    func addFolderNamed(as name: String, in directory: String) -> Bool
    
    /// Добавляет файл. Возвращает true в случае удачи и false в случае неудачи.
    func addFile(as name: String, in directory: String) -> Bool
    
    /// Удаляет файл или папку.
    func delete(at path: String, withName name: String)
    
}

struct FileManagerService: FileManagerServiceProtocol {
        
    enum AppDirectories: String, CaseIterable {
        case Documents = "Documents"
        case Inbox = "Inbox"
        case Library = "Library"
        case Tmp = "tmp"
    }
    
    func getContent(for directory: String) -> [String]? {
        guard let directoryPath = getURL(for: directory)?.path,
              let directory = try? FileManager.default.contentsOfDirectory(atPath: directoryPath)else { return nil }
        print("directoryPath: \(directoryPath)")
        return directory
    }
    
    func addFolderNamed(as name: String, in directory: String) -> Bool {
        guard var directoryPath = getURL(for: directory)?.path else {
            assertionFailure("\(#function) Can't create directory path!")
            return false
        }
        directoryPath += "/" + name
        do {
            try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
            return true
        }
        catch {
            assertionFailure("\(#function) Can't create folder!")
            return false
        }
    }
    
    //TODO: addFile
    func addFile(as name: String, in directory: String) -> Bool {
        return true
    }
    
    func delete(at path: String, withName name: String) {
        guard let filePath = getURL(for: path)?.appendingPathComponent(name) else {
            return
        }
        try? FileManager.default.removeItem(at: filePath)
    }
    
    func writeFile(containing: String, to path: String, withName name: String) {
        let filePath = (getURL(for: path)?.path)! + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }

    private func getURL(for directory: String) -> URL? {
        switch directory {
        case "Documents":
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            return documents
        case "Inbox":
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(AppDirectories.Inbox.rawValue) else {
                return nil
            }
            if FileManager.default.fileExists(atPath: "\(url)") {
            } else {
                //10
                try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            }
            return url
        case "Library":
            guard let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                return nil
            }
            return library
        case "Tmp":
            return FileManager.default.temporaryDirectory
        default:
            return nil
        }
    }
    
}

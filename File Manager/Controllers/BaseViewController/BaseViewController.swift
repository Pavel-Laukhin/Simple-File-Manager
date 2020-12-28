//
//  ViewController.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

class BaseViewController: UIViewController {
    
    var fileManager: FileManagerServiceProtocol = FileManagerService()
    var foldersAndFilesList: [[String]] = [[],[]]
    private(set) var currentDirectory: String
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    // MARK: - Life cycle
    init(title: String, at path: String) {
        currentDirectory = path
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fillFoldersAndFilesList()
        addSubviews()
        setupSubviews()
    }
    
    private func setupUI() {
        let addFolderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addDirectory"), style: .plain, target: self, action: #selector(addNewFolder))
        let addFileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addFile"), style: .plain, target: self, action: #selector(addNewFile))
        navigationItem.rightBarButtonItems = [addFileButton, addFolderButton]
    }
    
    private func fillFoldersAndFilesList() {
        guard let contentList = fileManager.getContent(for: currentDirectory) else {
            assertionFailure("\(#function) Can't make content list!")
            return
        }
        var foldersList: [String] = []
        var filesList: [String] = []
        for item in contentList {
            if item.first == "." { // Пропускаем скрытые файлы и папки
                continue
            }
            guard let url = fileManager.urlForItemNamed(as: item, inDirectory: currentDirectory) else {
                assertionFailure("\(#function) There is no item with name: \(item)")
                return
            }
            if url.hasDirectoryPath {
                foldersList.append(item)
            } else {
                filesList.append(item)
            }
        }
        foldersAndFilesList[0] = foldersList.sorted { $0.lowercased() < $1.lowercased() }
        foldersAndFilesList[1] = filesList.sorted { $0.lowercased() < $1.lowercased() }
    }
    
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupSubviews() {
        tableView.toAutoLayout()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func addNewFolder() {
        let alert = UIAlertController(title: "Directory name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty,
                  let checkedName = fileManager.addNewFolder(namedAs: name, to: currentDirectory) else {
                assertionFailure("Can't make folder with new name!")
                return
            }
            let index = foldersAndFilesList[0].insertionIndex(of: checkedName)
            foldersAndFilesList[0].insert(checkedName, at: index)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .right)
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addNewFile() {
        let alert = UIAlertController(title: "File name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let contentString = "Hello world!"
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty,
                  let checkedName = fileManager.addNewFile(namedAs: name, containing: contentString, toDirectory: currentDirectory) else {
                assertionFailure("Can't make file with new name!")
                return
            }
            let index = foldersAndFilesList[1].insertionIndex(of: checkedName)
            foldersAndFilesList[1].insert(checkedName, at: index)
            let indexPath = IndexPath(row: index, section: 1)
            tableView.insertRows(at: [indexPath], with: .right)
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
    }
    
}


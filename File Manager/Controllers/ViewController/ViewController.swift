//
//  ViewController.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let fileManager = FileManagerService()
    var foldersAndFilesList: [[String]] = [[],[]]
    private(set) var directoryPath: String
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    // MARK: - Life cycle
    init(title: String, at path: String) {
        directoryPath = path
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupSubviews()
    }
    
    private func setupUI() {
        // add buttons to nav bar
        let addFolderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addDirectory"), style: .plain, target: self, action: #selector(addFolder))
        let addFileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addFile"), style: .plain, target: self, action: #selector(addFile))
        navigationItem.rightBarButtonItems = [addFileButton, addFolderButton]
        
        //add files and folders
        guard let contentList = fileManager.getContent(for: directoryPath) else {
            assertionFailure("\(#function) Can't make content list!")
            return
        }
        foldersAndFilesList[0] = contentList.sorted { $0.lowercased() < $1.lowercased() }
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
    @objc private func addFolder() {
        let alert = UIAlertController(title: "Directory name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                if fileManager.addFolderNamed(as: name, to: directoryPath) {
                    let index = foldersAndFilesList[0].insertionIndex(of: name)
                    foldersAndFilesList[0].insert(name, at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    tableView.insertRows(at: [indexPath], with: .right)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addFile() {
        let alert = UIAlertController(title: "File name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let contentString = "Hello world!"
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                if fileManager.addFile(containing: contentString, toDirectory: directoryPath, withName: name) {
                    let index = foldersAndFilesList[1].insertionIndex(of: name)
                    foldersAndFilesList[1].insert(name, at: index)
                    let indexPath = IndexPath(row: index, section: 1)
                    tableView.insertRows(at: [indexPath], with: .right)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
//        fileManager.addFile()
    }

}


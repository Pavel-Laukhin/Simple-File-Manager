//
//  ViewController.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let fileManager = FileManagerService()
    var contentList: [[String]] = [[]]
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    // MARK: - Life cycle
    init(title: String) {
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
        if let title = title,
           let contentList = fileManager.getContent(for: title) {
            self.contentList[0] = contentList.sorted { $0.lowercased() < $1.lowercased() }
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.toAutoLayout()
    }
    
    private func setupSubviews() {
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
                if fileManager.addFolderNamed(as: name, in: title ?? "Documents") {
                    let index = contentList[0].insertionIndex(of: name)
                    contentList[0].insert(name, at: index)
                    
                    // 1-й вариант вставки:
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
        let createAction = UIAlertAction(title: "Create", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        present(alert, animated: true, completion: nil)
//        fileManager.addFile()
    }

}


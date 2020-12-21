//
//  ViewController.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        title = "Documents"
        
        setupUI()
        addSubviews()
        setupSubviews()
    }
    
    private func setupUI() {
        // add buttons to nav bar
    }

    
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.toAutoLayout()
    }
    
    private func setupSubviews() {
        NSLayoutConstraint.activate([
            // add constrains
        ])
    }


}


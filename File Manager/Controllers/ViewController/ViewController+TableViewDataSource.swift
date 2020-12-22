//
//  ViewController+TableViewDataSource.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return foldersAndFilesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldersAndFilesList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = foldersAndFilesList[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "directory")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "file")
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

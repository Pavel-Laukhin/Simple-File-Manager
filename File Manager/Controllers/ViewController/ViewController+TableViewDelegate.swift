//
//  ViewController+TableViewDelegate.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let folderName = foldersAndFilesList[indexPath.section][indexPath.row]
            let vc = ViewController(title: folderName, at: (currentDirectory + "/" + folderName))
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let fileName = foldersAndFilesList[indexPath.section][indexPath.row]
            let content = fileManager.readFile(withName: fileName, from: currentDirectory)
            let vc = FileContentViewController(title: fileName, content: content)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, complete in
            let itemName = foldersAndFilesList[indexPath.section][indexPath.row]
            fileManager.deleteItem(withName: itemName, inDirectory: currentDirectory)
            foldersAndFilesList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

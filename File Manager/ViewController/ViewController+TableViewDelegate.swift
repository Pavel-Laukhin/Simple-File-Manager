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
            let folderName = contentList[indexPath.section][indexPath.row]
            let vc = ViewController(title: folderName)
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            //TODO: Сделать контроллер с содержимым файла:
//            let fileName = contentList[indexPath.section][indexPath.row]
//            let vc =
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, complete in
            let folderName = contentList[indexPath.section][indexPath.row]
            fileManager.delete(at: title ?? "", withName: folderName)
            contentList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

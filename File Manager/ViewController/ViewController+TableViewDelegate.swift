//
//  ViewController+TableViewDelegate.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let city = cities.list[indexPath.row]
//        let vc = DetailViewController(forCity: city)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, complete in

//            CitiesImpl.shared.removeCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

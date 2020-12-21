//
//  ViewController+TableViewDataSource.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else { return UITableViewCell() }
//        cell.imageView =
//        cell.textLabel =
        return cell
    }
    
}

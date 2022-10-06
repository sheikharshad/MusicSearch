//
//  CellConfigurable.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//
import UIKit

protocol CellFetchable {
    associatedtype Cell: UITableViewCell
    func configure(cell: Cell, index: IndexPath)
}

protocol CellConfigurable {
    func getCell(for tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell
}

extension CellFetchable where Self: CellConfigurable {

    func getCell(for tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        var cell = UITableViewCell.init()
        if let instanceCell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell {
            configure(cell: instanceCell, index: indexPath)
            cell = instanceCell
        }
        return cell
    }
}

typealias CellRepresentableModel = CellFetchable & CellConfigurable

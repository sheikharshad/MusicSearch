//
//  TrackCell.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

final class TrackCell: UITableViewCell {

    @IBOutlet fileprivate private(set) weak var artistLabel, durationLabel, nameLabel: UILabel!
}

struct TrackCellModel: CellRepresentableModel {

    let artist: String?
    let duration: String?
    let name: String?

    func configure(cell: TrackCell, index: IndexPath) {
        cell.artistLabel.text = artist
        cell.durationLabel.text = duration
        cell.nameLabel.text = name
    }
}

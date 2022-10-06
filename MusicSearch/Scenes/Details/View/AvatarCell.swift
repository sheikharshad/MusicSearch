//
//  AvatarCell.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//
import UIKit

final class AvatarCell: UITableViewCell {

    @IBOutlet fileprivate private(set) weak var albumImage: UIImageView!
}

struct AvatarModel: CellRepresentableModel {

    let image: String?

    func configure(cell: AvatarCell, index: IndexPath) {
        cell.albumImage?.imageUrl = image
    }
}

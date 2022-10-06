//
//  AlbumListCell.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit
import Kingfisher

protocol AlbumListDataType: SearchType {

    var artist: String? { get }
    var canStream: Bool { get }
    var name: String? { get }
    var link: String? { get }
    var thumbImage: String? { get }
}

struct AlbumListModel: AlbumListDataType, CellRepresentableModel {

    var artist: String?
    var canStream: Bool
    var name: String?
    var link: String?
    var thumbImage: String?
    var album: String?
    var mbID: String?

    func configure(cell: AlbumListCell, index: IndexPath) {
        cell.configure(data: self)
    }
}

final class AlbumListCell: UITableViewCell {

    @IBOutlet private weak var artistLabel, streamableLabel, nameLabel: UILabel!
    @IBOutlet private weak var thumbNailImageView: LoaderImageView!
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var openLinkButton: UIButton!
    private var link: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.applyBorder()
    }

    func configure(data: AlbumListDataType) {
        artistLabel.text = data.artist
        streamableLabel.isHidden = !data.canStream
        nameLabel.text = data.name
        thumbNailImageView.applyBorder()
        thumbNailImageView.imageUrl = data.thumbImage
        self.link = data.link
        if link != nil {
            openLinkButton.isHidden = false
        } else {
            openLinkButton.isHidden = true
        }

    }

    @IBAction func onTapLink() {
        if let link = self.link ,
           let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

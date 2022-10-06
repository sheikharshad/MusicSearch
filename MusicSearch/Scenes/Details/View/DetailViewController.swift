//
//  DetailViewController.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit
import Combine

protocol SearchType {

    var album: String? { get }
    var artist: String? { get }
    var mbID: String? { get }
}

final class DetailViewController: UITableViewController, StoryBoardInitializable, CoordinatorViewController {

    weak var coordinator: DetailCoordinator?
    private struct Search: SearchType {
        var album: String?
        var artist: String?
        var mbID: String?
    }

    private(set) var viewModel = DetailViewModel()
    private let cancelBag = CancelBag()
    private lazy var loader = Loader(view: self.view)

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        viewModel.fetch()
    }

    private func bindUI() {
        viewModel
            .loader
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                $0 ? self?.loader.show(): self?.loader.hide()
            }.store(in: cancelBag)
        viewModel
            .cells
            .filter({!$0.isEmpty})
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: cancelBag)
        viewModel
            .errorMessage
            .sink { [weak self]  in
                self?.alert(title: "Error",
                            message: $0,
                            buttons: [.init(text: "Ok", style: .default)],
                            completion: { _, _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            }.store(in: cancelBag)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cells.value[indexPath.row].getCell(for: tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.value.count
    }
}

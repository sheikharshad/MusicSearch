//
//  AlbumSearchViewController.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit
import Combine

fileprivate extension UISearchController {

    static func searchController(
        delegate: UISearchResultsUpdating
    ) -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }
}

final class AlbumSearchViewController: UITableViewController, StoryBoardInitializable, CoordinatorViewController {

    private let cancelBag = CancelBag()
    private(set) var viewModel: AlbumSearchViewModel = AlbumSearchViewModel(searchRepo: SearchRepository())
    var coordinator: MainCoordinator?
    lazy var searchController = UISearchController.searchController(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        bindUI()
    }

    private func bindUI() {
        viewModel.loader.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.searchController.searchBar.isLoading = $0
            }).store(in: cancelBag)
        viewModel.needReload
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }).store(in: cancelBag)
        viewModel.navigateToDetail.sink { [weak self] in
            self?.coordinator?.showDetail(name: $0.album, artist: $0.artist, mbid: $0.mbID)
        }.store(in: cancelBag)
    }

    private func setupSearchUI() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.item(at: indexPath.row).getCell(for: tableView, cellForRowAt: indexPath)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.onScroll(position: scrollView.contentOffset.y,
                           contentHeight: tableView.contentSize.height,
                           frameHeight: scrollView.frame.size.height)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchCount
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onSelect(index: indexPath.row)
    }

}

extension AlbumSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(text: searchController.searchBar.text)
    }
}

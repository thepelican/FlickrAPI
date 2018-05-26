//
//  ViewController.swift
//  FlickrDeloitte
//
//  Created by Leonard Wu on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

    private let tableView = UITableView()
    private let cellIdentifier = "cellIdentifier"
    private var viewModel: ViewModel!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for university"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ViewModel(query: searchController.searchBar.rx.text.orEmpty.asObservable())
        
        configureProperties()
        configureLayout()
        configureReactiveBinding()
    }
    
    private func configureProperties() {
        tableView.register(FlickrTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.searchController = searchController
        searchController.searchBar.text = "test"
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.title = "University finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
    }
    
    private func configureLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    private func configureReactiveBinding() {
        
//            .map { ($0 ?? "").lowercased() }
//            .flatMap { request -> Observable<[FlickrObject]> in
//                return viewModel.getFlickrPhotosContainer(text: request)
//            }
        
            viewModel.flickerObjectList.drive(tableView.rx.items(cellIdentifier: cellIdentifier))
            { index, model, cell in
                cell.textLabel?.text = model.title
                cell.imageView?.sd_setImage(with: self.viewModel.getImageURL(model), placeholderImage: UIImage(named: "Placeholder.jpg"))
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            .disposed(by: viewModel.disposeBag)
        
//        tableView.rx.modelSelected(UniversityModel.self)
//            .map { URL(string: $0.webPages?.first ?? "")! }
//            .map { SFSafariViewController(url: $0) }
//            .subscribe(onNext: { [weak self] safariViewController in
//                self?.present(safariViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .subscribe { [weak self] _ in
                if (self?.searchController.searchBar.isFirstResponder)! {
                    _ = self?.searchController.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: viewModel.disposeBag)
    }

    //MARK - SEARCHBAR Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        searchBar.resignFirstResponder()
        searchController.isActive = false
        searchController.searchBar.text = text
    }
    
    
    //MARK - TABLEVIEW SCROLLVIEW Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.page.accept(viewModel.page.value + 1)
        }
    }
}


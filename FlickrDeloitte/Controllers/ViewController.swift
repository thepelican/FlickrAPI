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

class ViewController: UIViewController {

    private let tableView = UITableView()
    private let cellIdentifier = "cellIdentifier"
    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for university"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        configureReactiveBinding()
    }
    
    private func configureProperties() {
        tableView.register(FlickrTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.searchController = searchController
        navigationItem.title = "University finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
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
        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .flatMap { request -> Observable<[FlickrObject]> in
                return viewModel.getFlickrPhotosContainer(text: request)
            }
        
            viewModel.flickerObjectList.drive(tableView.rx.items(cellIdentifier: cellIdentifier))
{ index, model, cell in
                cell.textLabel?.text = "suka"
                cell.detailTextLabel?.text = "suak"
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(UniversityModel.self)
//            .map { URL(string: $0.webPages?.first ?? "")! }
//            .map { SFSafariViewController(url: $0) }
//            .subscribe(onNext: { [weak self] safariViewController in
//                self?.present(safariViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
    }

}


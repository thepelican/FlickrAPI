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
        
        
        configureProperties()
        configureLayout()
        
        self.viewModel = ViewModel()
        
        configureReactiveBinding()
        
    }
    
    private func configureProperties() {
        tableView.register(FlickrTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.searchController = searchController
        searchController.searchBar.text = "kitten"
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
        
        searchController.searchBar.rx.text.orEmpty.asObservable().bind(to: viewModel.query)
        
        viewModel.flickerObjectList.asDriver().drive(tableView.rx.items(cellIdentifier: cellIdentifier))
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
//        viewModel.page.accept(viewModel.page.value + 1)
        searchController.searchBar.text = text
    }
    
    
    //MARK - TABLEVIEW Delegate

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.flickerObjectList.value.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//        let item = viewModel.flickerObjectList.va[indexPath.row]
//        cell.textLabel?.text = item.title
//        cell.imageView?.sd_setImage(with: viewModel.getImageURL(item), placeholderImage: UIImage(named: "Placeholder.png"))
//
//        return cell
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let actualPosition = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height - (self.tableView.frame.size.height);
        if actualPosition >= contentHeight {
            // fetch resources

        }
    }
}


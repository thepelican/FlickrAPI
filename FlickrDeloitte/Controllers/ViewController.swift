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
    private var viewModel: ViewModel!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "FLICKR SEARCH"
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
        navigationItem.searchController = searchController
        searchController.searchBar.text = "kitten"
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.title = "Flikr"
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
        tableView.register(UINib(nibName:"FlickrTableViewCell", bundle: nil) , forCellReuseIdentifier: "FlickrTableViewCell")

        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        self.tableView.tableFooterView = spinner;
    }
    
    private func configureReactiveBinding() {
        
        searchController.searchBar.rx.text.orEmpty.asObservable().bind(to: viewModel.query).disposed(by: viewModel.disposeBag)
        
        viewModel.flickerObjectList.asDriver().drive(tableView.rx.items(cellIdentifier: "FlickrTableViewCell"))
        { index, model, cell in
            let cellRow = cell as! FlickrTableViewCell
            if let first = model.itemOne {
                cellRow.imgOne.sd_setImage(with: self.viewModel.getImageURL(first), placeholderImage: UIImage(named: "Placeholder.jpg"))
                cellRow.titleOne.text = first.title
            } else {
                cellRow.imgOne.image = UIImage(named: "Placeholder.jpg")
                cellRow.titleOne.text = ""
            }
            
            if let second = model.itemTwo {
                cellRow.imgTwo.sd_setImage(with: self.viewModel.getImageURL(second), placeholderImage: UIImage(named: "Placeholder.jpg"))
                cellRow.titleTwo.text = second.title
            } else {
                cellRow.imgTwo.image = UIImage(named: "Placeholder.jpg")
                cellRow.titleTwo.text = ""
            }
            
            if let third = model.itemThree {
                cellRow.imgThree.sd_setImage(with: self.viewModel.getImageURL(third), placeholderImage: UIImage(named: "Placeholder.jpg"))
                cellRow.titleThree.text = third.title
            } else {
                cellRow.imgThree.image = UIImage(named: "Placeholder.jpg")
                cellRow.titleThree.text = ""
            }
            }
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx.contentOffset
            .subscribe { [weak self] _ in
                if (self?.searchController.searchBar.isFirstResponder)! {
                    _ = self?.searchController.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx.willDisplayCell.subscribe{ [weak self] (willDisplayEvent) in
            if let vm = self?.viewModel {
                if (willDisplayEvent.element?.indexPath.row == vm.flickerObjectList.value.count - 1) {
                    self?.viewModel.page.value = vm.page.value + 1
                }
            }

        }.disposed(by: viewModel.disposeBag)
        
        
        searchController.searchBar.rx.searchButtonClicked.subscribe { [weak self] (clicked) in
            if let svc = self?.searchController,  let sb = self?.searchController.searchBar, let vm = self?.viewModel {
                let text = sb.text
                sb.resignFirstResponder()
                svc.isActive = false
                vm.page.value = 1
                svc.searchBar.text = text
            }
        }.disposed(by: viewModel.disposeBag)
    }


}


//
//  ViewController.swift
//  FlickrDeloitte
//
//  Created by Marco Prayer on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
//    private let tableView = UITableView()
    private var viewModel: ViewModel!
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProperties()
        configureLayout()
        
        self.viewModel = ViewModel()
        
        configureReactiveBinding()
        
    }
    
    private func configureProperties() {
        navigationItem.title = "Flickr"
        tableView.delegate = self
    }
    
    private func configureLayout() {

        self.tableView.register(UINib(nibName:"FlickrTableViewCell", bundle: nil) , forCellReuseIdentifier: "FlickrTableViewCell")
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        self.tableView.tableFooterView = spinner;
        
        tableView.refreshControl = refreshControl
        
    }
    
    private func configureReactiveBinding() {
        
        searchBar.rx.text.orEmpty.asObservable().bind(to: viewModel.query).disposed(by: viewModel.disposeBag)
        
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
                if (self?.searchBar.isFirstResponder)! {
                    _ = self?.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx.willDisplayCell.subscribe{ [weak self] (willDisplayEvent) in
            if let vm = self?.viewModel {
                if (willDisplayEvent.element?.indexPath.row == vm.flickerObjectList.value.count - 1)
                    && vm.flickerObjectList.value.count != 0 {
                    self?.viewModel.page.value = vm.page.value + 1
                }
            }

        }.disposed(by: viewModel.disposeBag)
        
        
        searchBar.rx.searchButtonClicked.subscribe { [weak self] (clicked) in
            if  let sb = self?.searchBar, let vm = self?.viewModel {
                let text = sb.text
                sb.resignFirstResponder()
                vm.page.value = 1
                sb.text = text
            }
        }.disposed(by: viewModel.disposeBag)
        
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in !self.refreshControl.isRefreshing }
            .filter { $0 == false }
            .map {_ in self.viewModel.refreshResults(query: self.viewModel.query.value) }
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in self.refreshControl.isRefreshing }
            .filter { $0 == true }
            .subscribe({ [unowned self] _ in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: self.viewModel.disposeBag)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


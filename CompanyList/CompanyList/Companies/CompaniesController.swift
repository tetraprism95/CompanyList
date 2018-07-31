//
//  ViewController.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/22/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    let cellId = "cellId"
    
    var companies = [Company]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitle()
        setupNavigationBarItems()
        setupTableView()
        self.companies = CoreDataManager.shared.fetchCompanies()
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        refreshControl.tintColor = .white
//        self.refreshControl = refreshControl
     }
    
    
//    @objc func handleRefresh() {
//        self.companies = CoreDataManager.shared.fetchCompanies()
//        self.companies = CoreDataManager.shared.deleteRequest(companies: companies, tableView: tableView)
//        refreshControl?.endRefreshing()
//    }
}



// MARK: - UI Setup Methods

extension CompaniesController {
    
    private func setupNavBarTitle() {
        navigationItem.title = "Companies"
    }
    
    private func setupNavigationBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "reset", style: .plain, target: self, action: #selector(handleReset))
        
        setupPlusButtonItem(selector: #selector(handleAddCompany))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView?.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        tableView?.tableFooterView = UIView()
    }
    
    @objc private func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    // Create a function in CoreDataManager Class to reset?
    
    @objc private func handleReset() {
        let tableView = UITableView()
        self.companies = CoreDataManager.shared.deleteRequest(companies: companies, tableView: tableView)
        self.companies = CoreDataManager.shared.fetchCompanies()
    }
}

















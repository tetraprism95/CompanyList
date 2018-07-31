//
//  CompaniesControllerExtension.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didEditCompany(company: Company) {
        
        let row = companies.index(of: company)
        let indexPath = IndexPath(row: row!, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    func didAddCompany(company: Company) {
        
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

//
//  CompaniesController + UITableView.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        let company = companies[indexPath.row]
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeesController = EmployeesController()
        let company = companies[indexPath.row]
        employeesController.company = company
        
        self.navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .lightBlue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "No Companies Available..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete", handler: deleteActionHandler)
        deleteAction.backgroundColor = .lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit", handler: editActionHandler)
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    
    private func editActionHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.company = companies[indexPath.row]
        createCompanyController.delegate = self
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    private func deleteActionHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        
        let company = self.companies[indexPath.row]
        print("Attempting to delete company: \(company.name ?? "")")
        
        // 1. Remove the company from our tableView
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
        
        do {
            try context.save()
        } catch let saveErr {
            print("Could not save context: ", saveErr)
        }
    }
}

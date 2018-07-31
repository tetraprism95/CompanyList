//
//  EmployeesController.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// custom UILabel subclass

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, edgeInsets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController {
    
    let cellId = "cellId"
    
    var company: Company?
    var employees = [Employee]()
    var allEmployees = [[Employee]]()
    var employeeTypes = [EmployeeType.Executive.rawValue,
                         EmployeeType.SeniorManagement.rawValue,
                         EmployeeType.Staff.rawValue,
                         EmployeeType.Intern.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarTitle()
        setupNavigationBarItems()
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employee?.allObjects as? [Employee] else { return }
        
        allEmployees = []
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter{ $0.type == employeeType})
        }
        
//        let executives = companyEmployees.filter { $0.type == EmployeeType.Executive.rawValue }
//        let seniorManagement = companyEmployees.filter { $0.type == EmployeeType.SeniorManagement.rawValue }
//        let staff = companyEmployees.filter { $0.type == EmployeeType.Staff.rawValue }
//
//        allEmployees = [executives, seniorManagement, staff]
    }
}

// MARK: - setupUI methods

extension EmployeesController {
    
    private func setupNavBarTitle() {
        navigationItem.title = company?.name
    }
    
    private func setupNavigationBarItems() {
        setupPlusButtonItem(selector: #selector(handleAddEmployee))
    }
    
    @objc private func handleAddEmployee() {
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - UITablViewControllerDelegate/DataSource

extension EmployeesController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
//
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1 {
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
        
        label.text = employeeTypes[section]
        
        label.textColor = .darkBlue
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let employeeBirthday = employee.employeeInfo?.birthday {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy" 
            let birthdayFormateOfficial = dateFormatter.string(from: employeeBirthday)

            cell.textLabel?.text = "\(employee.name ?? "") | Birthday: \(birthdayFormateOfficial)"
        } else {
            cell.textLabel?.text = employee.name
        }
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
//        fetchEmployees()
//        tableView.reloadData()
        
        guard let section = employeeTypes.index(of: employee.type!) else { return }
        let row = allEmployees[section].count

        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}












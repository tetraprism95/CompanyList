//
//  CoreDataManager.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/23/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompaniesModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                print("Loading of store description failed", err)
                return
            }
        }
        return container
    }()
    
    
    func fetchCompanies() -> [Company] {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch Companies: ", fetchErr)
            return []
        }
    }
    
    func deleteRequest(companies: [Company], tableView: UITableView) -> [Company] {
        
        var companies = companies
        let tableView = tableView
        
        print("delete all objects")
        let context = persistentContainer.viewContext
        let batchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchRequest)
            
            var indexPathToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
            return companies
            
        } catch let delErr {
            print("Delete all companies failed: ", delErr)
        }
        return [] 
    }
    
    func createEmployee(name: String, type: String, birthday: Date, company: Company) -> (Employee?, Error?) {
        
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        employee.type = type 
        employee.setValue(name, forKey: "name")
        
        
        let employeeInfo = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInfo", into: context) as! EmployeeInfo
        employeeInfo.birthday = birthday
        employee.employeeInfo = employeeInfo
        
    
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Failed to create employee: ", err)
            return (nil, err) 
        }
    }
}














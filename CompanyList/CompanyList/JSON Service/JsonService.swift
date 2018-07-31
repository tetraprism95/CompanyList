//
//  JsonService.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import CoreData


struct JsonService {
    
    static let shared = JsonService()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to download companies.", error)
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                
                jsonCompanies.forEach({ (jsonCompany) in
//                    print(jsonCompany.name)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
        
                    company.founded = foundedDate
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveError {
                        print("Save error: ", saveError)
                    }
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInformation = EmployeeInfo(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        
                        employee.employeeInfo = employeeInformation
                        employee.company = company
                        
//                        print("Employee Name: \(jsonEmployee.name) \n Birthday: \(jsonEmployee.birthday) \n Type: \(jsonEmployee.type)")
                    })
                })
            } catch let jsonError {
                print("Failed to decode", jsonError)
            }
        }.resume()
    }
}


struct JSONCompany: Decodable {

    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}


struct JSONEmployee: Decodable {
    
    let name: String
    let birthday: String
    let type: String
}















//
//  CreateEmployeeController.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let birthdayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Enter name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let birthdayTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "MM/dd/yyyy"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        
        let types = [EmployeeType.Executive.rawValue,
                     EmployeeType.SeniorManagement.rawValue,
                     EmployeeType.Staff.rawValue,
                     EmployeeType.Intern.rawValue]
        
        let sc = UISegmentedControl(items: types)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupNavBarTitle()
        setupNavBarItems()
        setupUI()
        
    }
}

extension CreateEmployeeController {
    
    private func setupBackgroundColor() {
        view.backgroundColor = .darkBlue
    }
    
    private func setupNavBarTitle() {
        navigationItem.title = "Create Employee"
    }
    
    private func setupNavBarItems() {
        setupCancelButtonItem()
        setupSaveButtonItem(selector: #selector(handleSave))
    }
    
    @objc func handleSave() {
        
        guard let name = nameTextField.text else { return }
        guard let company = company else { return }
        
        // Turn birthday into date object
        guard let birthday = birthdayTextField.text else { return }
        
        if birthday.isEmpty {
        
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let birthdayEmptyAlert = alert(title: "Birthday Empty", message: "You don't have a birthday?", preferredStyle: .alert, actionButton: okAction)
            
            present(birthdayEmptyAlert, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthday) else {
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let invalidBirthdayAlert = alert(title: "Invalid Birthday Input", message: "Please enter correct Birth Date", preferredStyle: .alert, actionButton: okAction)
    
            present(invalidBirthdayAlert, animated: true, completion: nil)
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        print(employeeType)
        
        let tuple = CoreDataManager.shared.createEmployee(name: name, type: employeeType, birthday: birthdayDate, company: company)
        
        if let error = tuple.1 {
            // Perhaps use a UIAlertController
            print("Error: ", error)
        } else {
            // creation success
            dismiss(animated: true) {
            self.delegate?.didAddEmployee(employee: tuple.0!) 
            }
        }
    }
    
    private func alert(title: String, message: String, preferredStyle: UIAlertControllerStyle, actionButton: UIAlertAction) ->   UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let preferredAction = actionButton
        
        alertController.addAction(preferredAction)
        
        return alertController
    }
    
    private func setupUI() {
        
        _ =  setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
}







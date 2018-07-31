//
//  CreateCompanyController.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/22/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            nameTextField.text = company?.name
            
            guard let founded = company?.founded else { return }
            
            datePicker.date = founded
        }
    }
    
    lazy var companyImageView: UIImageView = {
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        iv.layer.cornerRadius = iv.frame.width / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Enter name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        setupNavigationBarItem()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBarTitle()
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc func handleSelectPhoto() {
        print("Trying to select photo...")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func saveCompanyChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext

        guard let image = companyImageView.image else { return }
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        company?.imageData = imageData
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
    
    private func createCompany() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        guard let image = companyImageView.image else { return }
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        company.setValue(imageData, forKey: "imageData")
        
        do {
            print("saved \(nameTextField.text ?? "")")
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company: ", saveError)
        }
    }
}

// MARK: - UI Method Calls

extension CreateCompanyController {
    
    private func setupUI() {
        
        let lightBlueView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueView.bottomAnchor).isActive = true
     }
    
    private func setupNavBarTitle() {
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    private func setupNavigationBarItem() {
        setupCancelButtonItem()
        setupSaveButtonItem(selector: #selector(handleSave)) 
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateCompanyController {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as?  UIImage {
            companyImageView.image = originalImage 
        }
        
        dismiss(animated: true, completion: nil)
    }
}

















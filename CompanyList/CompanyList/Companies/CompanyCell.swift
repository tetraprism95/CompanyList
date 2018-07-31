//
//  CompanyCell.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            companyNameFoundedLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let dateFormattedString = dateFormatter.string(from: founded)
                
                let companyDetail = "\(name) - Founded: \(dateFormattedString)"
                
                companyNameFoundedLabel.text = companyDetail
            } else {
                companyNameFoundedLabel.text = company?.name
            }
        }
    }
    
    let companyImageView: UIImageView = {
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.layer.borderColor = UIColor.darkBlue.cgColor
        iv.layer.borderWidth = 1.5
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let companyNameFoundedLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Company Label"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupBackgroundCellColor()
        setupCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - setupCellUI()

extension CompanyCell {
    
    private func setupBackgroundCellColor() {
        backgroundColor = .tealColor
    }
    
    private func setupCellUI() {
        
        addSubview(companyImageView)
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(companyNameFoundedLabel)
        companyNameFoundedLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        companyNameFoundedLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        companyNameFoundedLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        companyNameFoundedLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}












//
//  UIViewController+Helper.swift
//  CompanyList
//
//  Created by Nuri Chun on 7/25/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupPlusButtonItem(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupSaveButtonItem(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    func setupCancelButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc private func handleCancelModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        
        let lightBlueView = UIView()
        lightBlueView.backgroundColor = .lightBlue
        lightBlueView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueView)
        lightBlueView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return lightBlueView
    }
}

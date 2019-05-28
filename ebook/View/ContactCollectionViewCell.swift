
//
//  ContactCollectionViewCell.swift
//  EasyBook
//
//  Created by Maxim Galayko on 3/28/16.
//  Copyright © 2016 Maxim Galayko. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var credentialsLabel: UILabel!
    
    static let reuseIdentifier = "ContactCollectionViewReuseIdentifier"
    
    func clear() {
        imageView.image = nil
        nameLabel.text = nil
        credentialsLabel.text = nil
    }
}


extension ContactCollectionViewCell {
    func fillWithContactInfo(info: SwiftAddressBookPerson) {
        imageView?.image = info.image
        nameLabel.text = info.firstName
        
        if let image = info.image {
            imageView.image = image
        } else {
            let firstName = info.firstName ?? "", lastName = info.lastName ?? ""
            if firstName.count > 0 && lastName.count > 0 {
                credentialsLabel.text = "\(firstName.first!)\(lastName.first!)"
            }
        }
    }
}

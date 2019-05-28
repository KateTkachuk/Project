//
//  ContactTableViewCell.swift
//  EBook
//
//  Created by Maksym Galayko on 5/28/19.
//  Copyright © 2019 Kate Tkachuk. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ContactListTableViewCellReuseIdentifier"
    
    @IBOutlet var contactPhotoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var lastCallLabel: UILabel!
    @IBOutlet var credentialsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    func clear() {
        contactPhotoView.image = nil
        nameLabel.text = nil
        numberLabel.text = nil
        lastCallLabel.text = nil
        credentialsLabel.text = nil
    }
}

extension ContactTableViewCell {
    func fillWithContactInfo(info: SwiftAddressBookPerson) {
        
        let firstName = info.firstName ?? "", lastName = info.lastName ?? ""
        numberLabel.text = info.phoneNumbers?.first?.value
        
        nameLabel.text = "\(firstName) \(lastName)"
        
        if let image = info.image {
            contactPhotoView.image = image
        } else {
            if firstName.count > 0 && lastName.count > 0 {
                credentialsLabel.text = "\(firstName.first!)\(lastName.first!)"
            }
        }
    }
}

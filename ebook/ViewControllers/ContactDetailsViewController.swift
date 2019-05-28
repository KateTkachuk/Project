//
//  ContactDetailsViewController.swift
//  EasyBook
//
//  Created by Maxim Galayko on 3/27/16.
//  Copyright © 2016 Maxim Galayko. All rights reserved.
//

import UIKit

class ContactDetailsViewController: BaseViewController, EditContactProtocol {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoCredentialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var person: SwiftAddressBookPerson!

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePersonInfoFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeContact(sender: AnyObject) {
        swiftAddressBook?.removeRecord(person)
        swiftAddressBook?.save()
        navigationController?.popViewController(animated: true)
    }
    
    func updatePersonInfoFields() {
        let firstName = person.firstName ?? "", lastName = person.lastName ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
        
        if let image = person.image {
            photoView.image = image
            photoCredentialsLabel.text = nil
        } else {
            if firstName.characters.count > 0 && lastName.characters.count > 0 {
                photoCredentialsLabel.text = "\(firstName.first!)\(lastName.first!)"
            }
        }
        
        phoneLabel.text = person.phoneNumbers?.first?.value
        
        if person.phoneNumbers?.count ?? 0 > 1 {
            homeLabel.text = person.phoneNumbers?[1].value
        } else {
            homeLabel.text = nil
        }
        
        if person.phoneNumbers?.count ?? 0 > 2 {
            workLabel.text = person.phoneNumbers?[2].value
        } else {
            workLabel.text = nil
        }
        
        emailLabel.text = person.emails?.first?.value
        addressLabel.text = person.addresses?.first?.value[.street] as? String
    }
    
    // MARK: - Edit delegate
    
    func editContact(person: SwiftAddressBookPerson!, editType: EditContactType) {
        updatePersonInfoFields()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editController = segue.destination as? EditContactViewController {
            editController.person = person
            editController.type = .Edit
            editController.editDelegate = self
        }
    }

}

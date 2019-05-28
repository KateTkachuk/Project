//
//  ContactsDataSourceModel.swift
//  EBook
//
//  Created by Maksym Galayko on 5/28/19.
//  Copyright © 2019 Kate Tkachuk. All rights reserved.
//

import UIKit

class ContactsDataSourceModel: NSObject {
    private(set) var contacts: [SwiftAddressBookPerson] = []
    
    var completionHandler: (() -> Void)?
    
    func fetchContacts() {
        SwiftAddressBook.requestAccessWithCompletion() { (success, error) -> Void in
            defer {
                DispatchQueue.main.async {
                    self.completionHandler?()
                }
            }
            guard success else {
                print("error fetching contacts")
                return
            }
            self.contacts = swiftAddressBook.allPeople ?? []
        }
    }
}

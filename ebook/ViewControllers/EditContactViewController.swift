//
//  EditContactViewController.swift
//  EasyBook
//
//  Created by Maxim Galayko on 3/27/16.
//  Copyright © 2016 Maxim Galayko. All rights reserved.
//

import UIKit

enum EditContactType {
    case Edit
    case Add
}

protocol EditContactProtocol: NSObjectProtocol {
    func editContact(person: SwiftAddressBookPerson!, editType: EditContactType)
}

class EditContactViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: ContactImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var homeTextField: UITextField!
    @IBOutlet var workTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var scrollView: UIScrollView!
    
    weak var editDelegate: EditContactProtocol?
    
    var person: SwiftAddressBookPerson?
    var type: EditContactType = .Add
    
    deinit {
        unregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDependencies()
        fillFields()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Fill Fields
    
    func fillFields() {
        if type == .Edit {
            imageView.image = person?.image
            
            let firstName = person?.firstName ?? "", lastName = person?.lastName ?? ""
            nameTextField.text = firstName
            lastNameTextField.text = lastName
            phoneTextField.text = person?.phoneNumbers?.first?.value
            if person?.phoneNumbers?.count ?? 0 > 1 {
                homeTextField.text = person?.phoneNumbers?[1].value
            } else {
                homeTextField.text = nil
            }
            if person?.phoneNumbers?.count ?? 0 > 2 {
                workTextField.text = person?.phoneNumbers?[2].value
            } else {
                workTextField.text = nil
            }

            emailTextField.text = person?.emails?.first?.value
            addressTextField.text = person?.addresses?.first?.value[.street] as? String
        } else {
            for textField in textFields {
                textField.text = nil
            }
        }
    }
    
    // MARK: - Keyboard Support
    
    func updateDependencies() {
        for textField in textFields {
            textField.delegate = self
            textField.autocorrectionType = .no
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo!
        guard let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let height = keyboardSize.height
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
        scrollView.contentInset = contentInsets
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.layoutIfNeeded()
        scrollView.contentInset = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIImagePickerController
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Changes
    
    @IBAction func updateImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(sender: AnyObject) {
        if type == .Add {
            person = SwiftAddressBookPerson.create()
        }
        
        person?.firstName = nameTextField.text
        person?.lastName = lastNameTextField.text
        
        _ = person?.setImage(imageView.image)
        
        let phone = MultivalueEntry(value: phoneTextField.text ?? "", label: "phone", id: 0)
        let home = MultivalueEntry(value: homeTextField.text ?? "", label: "home", id: 0)
        let work = MultivalueEntry(value: workTextField.text ?? "", label: "work", id: 0)
        person?.phoneNumbers = [phone, home, work]
        
        let email = MultivalueEntry(value: emailTextField.text ?? "", label: "email", id: 0)
        person?.emails = [email]
        
        let addressDictRecord = [SwiftAddressBookAddressProperty.street: (addressTextField.text ?? "") as AnyObject] as [SwiftAddressBookAddressProperty : Any]
        let address = MultivalueEntry(value: addressDictRecord, label: "street", id: 0)
        
        person?.addresses = [address]
        
        if type == .Add {
            _ = swiftAddressBook.addRecord(person!)
        }
        _ = swiftAddressBook.save()
        
        navigationController?.popViewController(animated: true)
        editDelegate?.editContact(person: person, editType: type)
    }
}

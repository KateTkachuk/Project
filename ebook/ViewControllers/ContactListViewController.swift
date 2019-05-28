//
//  ViewController.swift
//  EasyBook
//
//  Created by Maxim Galayko on 3/26/16.
//  Copyright © 2016 Maxim Galayko. All rights reserved.
//

import UIKit

class ContactListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var contactsDataSource = ContactsDataSourceModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadContacts()
        
        updatePresentationView(sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePresentationView(sender: AnyObject) {
        if segmentControl.selectedSegmentIndex == 0 {
            collectionView.isHidden = true
            tableView.isHidden = false
        } else {
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    // MARK: - TableView
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func reloadContacts() {
        contactsDataSource.completionHandler = {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        contactsDataSource.fetchContacts()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsDataSource.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier, for: indexPath) as! ContactTableViewCell
        cell.clear()
        
        cell.fillWithContactInfo(info: contactsDataSource.contacts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    
    // MARK: - CollectionView
    
    private func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactsDataSource.contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
        cell.clear()
        
        cell.fillWithContactInfo(info: contactsDataSource.contacts[indexPath.row])
        
        return cell
    }
    
    // MARK: - Segue
    
    func selectedPerson() -> SwiftAddressBookPerson? {
        if tableView.isHidden {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                return contactsDataSource.contacts[indexPath.row]
            }
        } else {
            if let indexPath = tableView.indexPathForSelectedRow {
                return contactsDataSource.contacts[indexPath.row]
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contactDetailsViewController = segue.destination as? ContactDetailsViewController {
            contactDetailsViewController.person = selectedPerson()
        }
        
        if let addContactController = segue.destination as? EditContactViewController {
            addContactController.type = .Add
        }
    }
    
    
}


//
//  ContactsMasterViewController.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import Cocoa

class ContactsMasterViewController: NSViewController {
    // MARK: - IBOutlet
    @IBOutlet var searchTextField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    // MARK: - Data manager
    let contactsDataManager = ContactsDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addObserver()
    }
    
    // MARK: - IBAction
    @IBAction func addNewAccount(_ sender: NSButton) {
        let newAccount = Contact(name: "New",
                                 surname: "Account",
                                 imagePhoto: nil,
                                 note: [
                                    Note(text: "")
                                 ])
        //TODO: Note create
        contactsDataManager.arrayOfAccounts.append(newAccount)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        let cell = NSNib(nibNamed: NSNib.Name("AccountInfoCell"), bundle: nil)
        tableView.register( cell.self , forIdentifier: AccountInfoCell.reuseIdentifier)

        for i in contactsDataManager.arrayOfAccounts.indices {
           //TODO: Note fix delegate
        }
    }
}

// MARK: - NSTableViewDelegate
extension ContactsMasterViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        guard let splitVC = parent as? NSSplitViewController else { return }

        if let detail = splitVC.children[1] as? DetailViewController {
            detail.configure(with: contactsDataManager.arrayOfAccounts[tableView.selectedRow])
            detail.view.isHidden = false
        }
    }
}

// MARK: - NSTableViewDataSource
extension ContactsMasterViewController: NSTableViewDataSource {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: AccountInfoCell.reuseIdentifier, owner: self) as? AccountInfoCell else {  return nil }
        
        let contactFullName = contactsDataManager.getContactFullName(at: row)
        cell.label.stringValue = contactFullName

        return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let filteredAccounts = contactsDataManager.filteredArray.count
        let arrayOfAccounts = contactsDataManager.arrayOfAccounts.count
        
        return  contactsDataManager.isFiltered ? filteredAccounts :  arrayOfAccounts
    }
}

extension ContactsMasterViewController {
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: NSNotification.Name("contactInfoDidChange"), object: nil)
    }
    
    @objc func updateLabel(_ notification: NSNotification) {
        if contactsDataManager.isFiltered {
            let searchText = searchTextField.stringValue
            contactsDataManager.contains(searchText)
        }

        tableView.reloadData()
    }
}

// MARK: -  NSTextFieldDelegate
extension ContactsMasterViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let searchTextField = obj.object as? NSTextField else { return }
        let searchText = searchTextField.stringValue
        
        contactsDataManager.isFiltered = !searchText.isEmpty
        contactsDataManager.contains(searchText)
        
        tableView.reloadData()
    }
}




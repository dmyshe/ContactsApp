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
        let newContacts = Contact(name: "New",
                                 surname: "Contacts",
                                 imagePhoto: nil,
                                 note: [
                                    Note(text: "")
                                 ])
        //TODO: Note create
        contactsDataManager.contacts.append(newContacts)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        let cell = NSNib(nibNamed: NSNib.Name("AccountInfoCell"), bundle: nil)
        tableView.register( cell.self , forIdentifier: AccountInfoCell.reuseIdentifier)

        for _ in contactsDataManager.contacts.indices {
           //TODO: Note fix delegate
        }
    }
}

// MARK: - NSTableViewDelegate
extension ContactsMasterViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        guard let splitVC = parent as? NSSplitViewController else { return }

        if let detail = splitVC.children[1] as? ContactDetailViewController {
            detail.configure(with: contactsDataManager.contacts[tableView.selectedRow])
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
        let filteredContacts = contactsDataManager.filteredContacts.count
        let contacts = contactsDataManager.contacts.count
        
        return  !contactsDataManager.isFiltered ? contacts :  filteredContacts
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




//
//  SourceViewController.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import Cocoa

class SourceViewController: NSViewController {

    // MARK: - IBOutlet
    @IBOutlet var searchTextField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchTextField.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func addNewAccount(_ sender: NSButton) {
        let newAccount = Account(name: "New",
                                 surname: "Account",
                                 imagePhoto: nil,
                                 note: [
                                    Note(text: "")
                                 ])
        newAccount.accountInfoDelegate = self
        dataManager.arrayOfAccounts.append(newAccount)
        reloadData()
    }
    
    private func setupTableView() {
        let cell = NSNib(nibNamed: NSNib.Name("AccountInfoCell"), bundle: nil)
        tableView.register( cell.self , forIdentifier: AccountInfoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        for i in dataManager.arrayOfAccounts.indices {
            dataManager.arrayOfAccounts[i].accountInfoDelegate = self
        }
    }
}

// MARK: - NSTableViewDelegate
extension SourceViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        guard let splitVC = parent as? NSSplitViewController else { return }

        if let detail = splitVC.children[1] as? DetailViewController {
            detail.configure(with: dataManager.arrayOfAccounts[tableView.selectedRow])
            detail.view.isHidden = false
        }
    }
}

// MARK: - NSTableViewDataSource
extension SourceViewController: NSTableViewDataSource {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let cell = tableView.makeView(withIdentifier: AccountInfoCell.identifier, owner: self) as? AccountInfoCell else {  return nil }
        
        let personFullName = dataManager.setPersonFullNameInArray(at: row)
        
        cell.label.stringValue = personFullName

        return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let filteredAccounts = dataManager.filteredArray.count
        let arrayOfAccounts = dataManager.arrayOfAccounts.count
        
        return  dataManager.isFiltered ? filteredAccounts :  arrayOfAccounts
    }
}

// MARK: -  AccountInfoDelegate
extension SourceViewController: AccountInfoDelegate {
    func accountInfoDidChange(_ account: Account) {
        
        if dataManager.isFiltered {
            dataManager.checkIfAcountContainsText(from: searchTextField.stringValue)
        }
        
        reloadData()
    }
    
    func reloadData() {        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: -  NSTextFieldDelegate
extension SourceViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let searchTextField = obj.object as? NSTextField else { return }
        
        dataManager.isFiltered = !searchTextField.stringValue.isEmpty
        
        dataManager.checkIfAcountContainsText(from: searchTextField.stringValue)
        
        reloadData()
    }
}




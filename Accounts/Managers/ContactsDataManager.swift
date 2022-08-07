//
//  ContactsDataManager.swift
//  Accounts
//
//  Created by Дмитро  on 06/05/22.
//

import Foundation

class ContactsDataManager {
    var contacts = Contact.exampleData
    var filteredContacts: [Contact] = []
    
    var isFiltered: Bool = false 
    
    func contains(_ text: String)  {
        filteredContacts.removeAll()
        
        guard text != " " else { return }
        
        let searchText = text.lowercased()
        
        
        contacts.forEach { account in
            let accountFullName = account.fullName.lowercased()
            
            if accountFullName.contains(searchText)  {
                filteredContacts.append(account)
            }
        }

        for (_,account) in contacts.enumerated() where account.note != nil {
            for (_,note) in account.note!.enumerated() where note.text.lowercased().contains(searchText)  {
                filteredContacts.append(account)
            }
        }
    }
    
    func getContactFullName(at index: Int) -> String  {
        return isFiltered ? filteredContacts[index].fullName : contacts[index].fullName
    }
}

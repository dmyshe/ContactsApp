//
//  DataManager.swift
//  Accounts
//
//  Created by Дмитро  on 06/05/22.
//

import Foundation


class DataManager {
    var arrayOfAccounts = Account.exampleData
    var filteredArray: [Account] = []
    
    var isFiltered: Bool = false 
    
    func checkIfAcountContainsText( from value: String)  {
        filteredArray.removeAll()
        
        guard value != " " else { return }
        
        let textFieldText = value.lowercased()
        
        arrayOfAccounts.forEach { account in
            if account.fullName.lowercased().contains(textFieldText)  {
                    filteredArray.append(account)
            }
        }

        for (_,account) in arrayOfAccounts.enumerated() where account.note != nil {
            for (_,note) in account.note!.enumerated() where note.text.lowercased().contains(textFieldText)  {
                    filteredArray.append(account)
            }
        }
    }
    
    func setPersonFullNameInArray(at index: Int) -> String  {
        return isFiltered ? filteredArray[index].fullName : arrayOfAccounts[index].fullName
    }
}

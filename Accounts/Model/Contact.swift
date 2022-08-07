//
//  Account.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import Foundation


protocol AccountTextFieldDelegate: AnyObject {
    func accountFullNameDidChange(_ account: Contact)
}

protocol AccountInfoDelegate: AnyObject {
    func reloadData()
    func accountInfoDidChange(_ account: Contact)
}


class Contact  {
    var name: String  {
        didSet {
            accountTextFieldDelegate?.accountFullNameDidChange(self)
            accountInfoDelegate?.accountInfoDidChange(self)
        }
    }
    
    var surname: String {
        didSet {
            accountTextFieldDelegate?.accountFullNameDidChange(self)
            accountInfoDelegate?.accountInfoDidChange(self)
        }
    }
    
    var fullName: String {
        get {
            "\(name) \(surname)"
        }
        set {
            separateFullName(newValue)
            accountTextFieldDelegate?.accountFullNameDidChange(self)
            accountInfoDelegate?.accountInfoDidChange(self)
        }
    }
    
    var imagePhoto: String?
    
    var note: [Note]? {
        didSet {
            accountInfoDelegate?.accountInfoDidChange(self)
        }
    }
    
    weak var accountTextFieldDelegate: AccountTextFieldDelegate?
    weak var accountInfoDelegate: AccountInfoDelegate?
    
    init(name: String, surname: String, imagePhoto: String?, note: Array<Note>? = nil) {
        self.name = name
        self.surname = surname
        self.imagePhoto = imagePhoto
        self.note = note
    }
    
    private func separateFullName(_ value: String) {
        let fullName = value.split(separator: " ")
        if fullName.count <= 1 {
            self.name = String(fullName[0])
            self.surname = " "
        } else {
            self.name = String(fullName[0])
            self.surname = String(fullName[1])
        }
    }
}

extension Contact {
    static var exampleData = [
        Contact(name: "James", surname: "Bond", imagePhoto: nil, note: [
        Note(text: "Hello everyone"),
        Note(text: "Nice")
        ]),
        Contact(name: "Sasha", surname: "Smiley", imagePhoto: nil, note: nil),
    ]
}


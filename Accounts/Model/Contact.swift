//
//  Account.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import Foundation

class Contact  {
    var name: String  {
        didSet {
            postNotificationCenter()
        }
    }
    
    var surname: String {
        didSet {
            postNotificationCenter()
        }
    }
    
    var fullName: String {
        get {
            "\(name) \(surname)"
        }
        set {
            separateFullName(newValue)
            postNotificationCenter()
        }
    }
    
    var imagePhoto: String?
    
    var note: [Note]? {
        didSet {
//            accountInfoDelegate?.contactInfoDidChange(self)
        }
    }
        
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
    
    private func postNotificationCenter() {
        let contactInfo: [String : Any] = ["name": name, "surname": surname,"fullName": fullName, "note": note as Any]
        NotificationCenter.default.post(name: NSNotification.Name("contactInfoDidChange"), object: nil,userInfo: contactInfo)
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


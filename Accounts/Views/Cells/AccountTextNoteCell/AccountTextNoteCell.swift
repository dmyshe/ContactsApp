//
//  AccountTextNoteCell.swift
//  Accounts
//
//  Created by Дмитро  on 05/05/22.
//

import Cocoa

protocol AccountTextNoteCellDelegate: AnyObject {
    func addNote(_ item: NSCollectionViewItem)
    func removeNote(_ item: NSCollectionViewItem)
    func noteTextFieldDidChange(_ item: NSCollectionViewItem)
}

class AccountTextNoteCell: NSCollectionViewItem {
    static let reuseIdentifier =  NSUserInterfaceItemIdentifier(rawValue: "AccountTextNoteCell")
     
    weak var delegate: AccountTextNoteCellDelegate?
    
    @IBOutlet var noteTextField: NSTextField!
 
    @IBAction func adjustNote( sender: NSSegmentedControl) {
        if sender.tag == 0 {
            delegate?.addNote(self)
        } else {
            delegate?.removeNote(self)
        }
    }
    
    public func configure(with textNote: String) {
        noteTextField.stringValue = textNote
        delegate?.noteTextFieldDidChange(self)
    }
    
    override func prepareForReuse() {
        noteTextField.stringValue = " "
    }
    
}

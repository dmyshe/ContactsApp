//
//  AccountInfoCell.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import AppKit

class AccountInfoCell: NSTableCellView {
    
    static  let identifier = NSUserInterfaceItemIdentifier(rawValue: "AccountInfoCell")
    
    @IBOutlet var label: NSTextField!
    
    override func prepareForReuse() {
        label.stringValue = ""
    }
}

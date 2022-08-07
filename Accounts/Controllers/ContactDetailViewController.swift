//
//  DetailViewController.swift
//  Accounts
//
//  Created by Дмитро  on 02/05/22.
//

import Cocoa


class ContactDetailViewController: NSViewController {
    // MARK: - IBOutlet
    @IBOutlet var contactAvatarImageView: NSImageView!
    @IBOutlet var contactFullNameTF: NSTextField!
    @IBOutlet var contactNameTF: NSTextField!
    @IBOutlet var contactSurnameTF: NSTextField!
    @IBOutlet var collectionView: NSCollectionView!
    
    private var model: Contact?
    
    private enum TextFieldType: Int {
        case fullName, name, surname
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureCollectionView()
        configureAvatarImage()
        self.view.isHidden = true
        
        addObserver()
    }

    public func configure(with model: Contact) {
        self.model = model

        guard let account = self.model else { return }
        
        contactFullNameTF.stringValue = account.fullName
        contactNameTF.stringValue = account.name
        contactSurnameTF.stringValue = account.surname
        
        if let path = model.imagePhoto {
            contactAvatarImageView.image = NSImage(contentsOf: URL(fileURLWithPath: path))
        }
        
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.enclosingScrollView?.borderType = .noBorder
        collectionView.register(AccountTextNoteCell.self, forItemWithIdentifier: AccountTextNoteCell.reuseIdentifier)
    }
    
    private func configureTextFields() {
        contactFullNameTF.delegate = self
        contactNameTF.delegate = self
        contactSurnameTF.delegate = self
    }
    
    private func configureAvatarImage() {
        contactAvatarImageView.image = NSImage(systemSymbolName: "person.crop.circle.fill", accessibilityDescription: nil)
    }
    
    // MARK: - IBAction
    @IBAction private func uploadImage(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.title = "Choose avatar photo"
        openPanel.begin { [weak self] result in
            if result == .OK, let imageURL = openPanel.url {
                self?.contactAvatarImageView.image = NSImage(contentsOf: imageURL )
                self?.model?.imagePhoto = imageURL.path
            } else {
                openPanel.close()
            }
        }
    }
}

// MARK: - NSCollectionViewDataSource
extension ContactDetailViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        guard let item = collectionView.makeItem(withIdentifier: AccountTextNoteCell.reuseIdentifier , for: indexPath) as? AccountTextNoteCell else {  return NSCollectionViewItem() }
       
        let textNote = model?.note?[indexPath.item].text ?? "Some text"

        item.delegate = self
        item.configure(with: textNote)
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.note?.count ?? 0
    }
}


// MARK: - NSTextFieldDelegate
extension ContactDetailViewController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        let textFieldType = TextFieldType(rawValue: textField.tag)
        
        switch textFieldType {
        case .fullName:
            model?.fullName = textField.stringValue
            
        case .name:
            model?.name = textField.stringValue
            
        case .surname:
            model?.surname = textField.stringValue
            
        case .none:
            print("textFieldType is undefined")
        }
    }
}

// MARK: - ChangeAccountFullNameDelegate
extension ContactDetailViewController {

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: NSNotification.Name("contactInfoDidChange"), object: nil)
    }
    
    @objc func updateLabel(_ notification: NSNotification) {
        if let contactName = notification.userInfo?["name"] as? String,
           let contactSurname = notification.userInfo?["surname"] as? String,
           let contactFullName = notification.userInfo?["fullName"] as? String {
            contactNameTF.stringValue = contactName
            contactSurnameTF.stringValue = contactSurname
            contactFullNameTF.stringValue = contactFullName
        }
    }
}

// MARK: - AccountTextNoteCellDelegate
extension ContactDetailViewController: AccountTextNoteCellDelegate {
    func addNote(_ item: NSCollectionViewItem) {
        guard  let item = collectionView.indexPath(for: item) else { return }
        let index = item.item

        let newNote = Note(text: "Text New")
        
        model?.note?.insert(newNote, at: index)
//        model?.note?.append(newNote)
        collectionView.reloadData()
    }
    
    func removeNote(_ item: NSCollectionViewItem) {
        guard  let item = collectionView.indexPath(for: item) else { return }
        let index = item.item
        
        model?.note?.removeLast()
        collectionView.reloadData()
    }
    
    func noteTextFieldDidChange(_ item: NSCollectionViewItem) {
        let textNote = item.textField?.stringValue
        guard  let item = collectionView.indexPath(for: item) else { return }
        let index = item.item
        
        model?.note?[index].text = textNote ?? " "
        collectionView.reloadData()
    }
}




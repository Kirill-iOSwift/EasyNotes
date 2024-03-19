//
//  AddNoteViewController.swift
//  EasyNotes
//
//  Created by Кирилл on 14.03.2024.
//

import UIKit

final class AddNoteViewController: UIViewController {
    
    // MARK: - Properties
    
    let textView = UITextView()
    var note: Note?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupUI()
        setupConstraints()
        changeColorPlaceholder()
    }
    
    //MARK: - Private methods
    
    @objc ///Метод сохраняет или обновляет заметку
    private func saveNote() {
        if note == nil {
            StorageManager.shared.create(noteText: textView.text ?? "")
        } else {
            guard let note = note else { return }
            StorageManager.shared.update(note: note, newText: textView.text ?? "")
        }
    }
    
    /// Метод настройки view
    private func setupUI() {
        
        title = "Write a note"
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        
        view.addSubview(textView)
        
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    ///Метод настройки subview
    private func setupProperties() {
        
        ///Скругляем углы subview
        textView.layer.cornerRadius = 10
            
        ///Выставляем размер шрифта
        textView.font = UIFont.systemFont(ofSize: 16)
        
        ///Меняем цвет курсора
        textView.tintColor = .black
    }
    
    ///Метод установки констрейнтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            ///TextView
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

// MARK: - UITextViewDelegate - Placeholder

extension AddNoteViewController: UITextViewDelegate {
    
    ///
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your text" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    ///
    func textViewDidEndEditing(_ textView: UITextView) {
        changeColorPlaceholder()
    }
    
    ///Метод изменения цвета
    private func changeColorPlaceholder() {
        if textView.text == "" {
            textView.text = "Type your text"
            textView.textColor = .lightGray
        }
    }
}

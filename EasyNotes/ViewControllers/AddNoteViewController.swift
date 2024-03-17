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
    let textField = UITextField()
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
        note == nil
        ? StorageManager.shared.create(noteTitle: textField.text ?? "", noteText: textView.text ?? "")
        : StorageManager.shared.update(note: note!, newTitle: textField.text ?? "", newText: textView.text ?? "")
        
        navigationController?.popViewController(animated: true)
    }
    
    /// Метод настройки view
    private func setupUI() {
        
        title = "Write a note"
        view.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        
        view.addSubview(textField)
        view.addSubview(textView)
        
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    ///Метод настройки subview
    private func setupProperties() {
        
        ///Скругляем углы subview
        textView.layer.cornerRadius = 10
        textField.layer.cornerRadius = 10
            
        ///Выставляем размер шрифта
        textView.font = UIFont.systemFont(ofSize: 16)
        textField.font = UIFont.systemFont(ofSize: 16)
        
        ///Меняем цвет курсора
        textField.tintColor = .black
        textView.tintColor = .black
        
        textField.placeholder = "Title"
        
        textField.backgroundColor = .white
        
        ///Делаем отступ текста от края
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftViewMode = .always
        
    }
    
    ///Метод установки констрейнтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ///TextField
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 35),
            
            ///TextView
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
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

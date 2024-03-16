//
//  AddNoteViewController.swift
//  EasyNotes
//
//  Created by Кирилл on 14.03.2024.
//

import UIKit

final class AddNoteViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    var textView = UITextView()
    var textField = UITextField()
    var note: Note?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProperties()
        setupConstraints()
        changeText()
    }
    
    // MARK: - UITextViewDelegate - Placeholder
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Your text" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type Your text"
            textView.textColor = .lightGray
        }
    }
    
    ///Метод изменения цвета
    private func changeText() {
        if textView.text == "" {
            textView.text = "Type Your text"
            textView.textColor = .lightGray
        }
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
        view.backgroundColor = .lightGray
        
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
        
        textField.backgroundColor = .systemGray6
        textView.backgroundColor = .systemGray6
        
        ///Делаем отступ текста от края
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
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
            
            ///TextView
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

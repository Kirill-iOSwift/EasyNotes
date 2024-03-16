//
//  ViewController.swift
//  EasyNotes
//
//  Created by Кирилл on 14.03.2024.
//

import UIKit

final class NoteViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var notes: [Note] = []
    private let storageManager = StorageManager.shared
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var firstStart = true
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        fetchData()
        getFirstObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    
    //MARK: - Private methods
    
    ///Метод настройки таблицы
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .lightGray
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    ///Метод настройки NavigationBar
    private func setupNavigationBar() {
        title = "Note List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(pushNextVC)
        )
    }
    
    @objc ///Метод перехода
    private func pushNextVC() {
        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }
    
    ///Метод вставки первого объекта с проверкой первого входа
    private func getFirstObject() {
        if UserDefaults.standard.object(forKey: "start") == nil {
            storageManager.firstObject()
            UserDefaults.standard.set("start", forKey: "start")
        }
    }
    
    ///Метод получения данных из СoreData
    private func fetchData() {
        storageManager.fetch { [unowned self] result in
            switch result {
            case .success(let notes):
                self.notes = notes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Table View Data Sourse

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = note.title
        content.secondaryText = note.text
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddNoteViewController()
        vc.note = notes[indexPath.row]
        vc.textField.text = notes[indexPath.row].title
        vc.textView.text = notes[indexPath.row].text
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(note: note)
        }
    }
}



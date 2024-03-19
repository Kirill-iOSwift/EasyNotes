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
    private let viewBottom = UIView()
    private let noteCountLabel = UILabel()
    private let buttunAdd = UIButton()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setConstraints()
        fetchData()
        getFirstObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        noteCountLabel.text = "Notes: \(notes.count)"
        tableView.reloadData()
    }
    
    //MARK: - Private methods
    
    ///Метод настройки таблицы
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(viewBottom)
        view.addSubview(noteCountLabel)
        view.addSubview(buttunAdd)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        noteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        buttunAdd.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .systemGray6
        viewBottom.backgroundColor = .systemGray6
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        noteCountLabel.font = UIFont(name: "system", size: 30)
        
        buttunAdd.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        buttunAdd.tintColor = .black
        buttunAdd.contentVerticalAlignment = .fill
        buttunAdd.contentHorizontalAlignment = .fill
        buttunAdd.addTarget(self, action: #selector(showAddVC), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBottom.heightAnchor.constraint(equalToConstant: 100),
            
            noteCountLabel.centerXAnchor.constraint(equalTo: viewBottom.centerXAnchor),
            noteCountLabel.centerYAnchor.constraint(equalTo: viewBottom.centerYAnchor),
            
            buttunAdd.heightAnchor.constraint(equalToConstant: 40),
            buttunAdd.widthAnchor.constraint(equalToConstant: 40),
            
            buttunAdd.trailingAnchor.constraint(equalTo: viewBottom.trailingAnchor, constant: -30),
            buttunAdd.centerYAnchor.constraint(equalTo: viewBottom.centerYAnchor)
        ])
    }
    
    ///Метод настройки NavigationBar
    private func setupNavigationBar() {
        title = "Note List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc ///Метод перехода
    private func showAddVC() {
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
    
    ///Метод форматирования даты и времени
    private func dateToString(format: String, date: Date?) -> String? {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let str = formatter.string (from: date)
        return str
    }
}

//MARK: - Methods Protokols

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Table View Data Sourse
    
    ///Колличество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    ///Настраиваем ячеку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        let time = dateToString(format: "HH:mm - dd.MM.yyyy", date: note.date)
        cell.accessoryType = .disclosureIndicator
        content.text = "\(time ?? "")"
        content.textProperties.font = .systemFont(ofSize: 16)
        content.textProperties.font = .boldSystemFont(ofSize: 16)
        content.secondaryText = note.text
        content.secondaryTextProperties.numberOfLines = 1
        content.secondaryTextProperties.font = .systemFont(ofSize: 16)
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: Table View Delegate
    
    ///При нажатии на ячейку переходим на экран редактирования и переносим данные
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddNoteViewController()
        vc.note = notes[indexPath.row]
        vc.textView.text = notes[indexPath.row].text
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///Метод удаления ячейки свайпом влево
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(note: note)
            noteCountLabel.text = "Notes: \(notes.count)"
        }
    }
}



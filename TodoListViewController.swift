//
//  TodoListViewController.swift
//  WeatherApp
//
//  Created by Bek Mashrapov on 2024-04-18.
//

import Foundation

import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource {
    var cityName: String?
    var todos: [String] = []
    var onTodosUpdated: (([String]) -> Void)?

    let tableView = UITableView()
    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = cityName ?? "To-Dos"
        
        setupTextField()
        setupAddButton()
        setupTableView()
    }
    
    private func setupTextField() {
        textField.placeholder = "Enter a to-do"
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupAddButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addTodo() {
        guard let todoText = textField.text, !todoText.isEmpty else { return }
        todos.append(todoText)
        tableView.reloadData()
        textField.text = ""
        onTodosUpdated?(todos)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row]
        return cell
    }
}


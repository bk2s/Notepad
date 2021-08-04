//
//  TableViewController.swift
//  Notepad
//
//  Created by  Stepanok Ivan on 03.08.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var notesArray = [Notes]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

 
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notesCell = notesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        
        cell.textLabel?.text = notesCell.name
        
        
        
        return cell

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToText", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TextViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectNote = notesArray[indexPath.row]
        }
    }
    
    
    //MARK: Delete item
    
    // Подпись к кнопке удалить
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    // Удаление ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Сначала удаляем из базы данных
            context.delete(notesArray[indexPath.row])
            // А потом уже с экрана. Иначе будет бедулька.
            self.notesArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
            tableView.reloadData()

        }
    }
    
    
    
    
    
    
    
    // Сохраняем данные через CoreData
    func saveItems() {
        
        do {
           try context.save()
            
        } catch {
            print(error)
        }
        
    }
    
    
    // Загружаем данные через CoreData
    // В функции можно указать значение по умолчанию.
    func loadItems(request: NSFetchRequest<Notes> = Notes.fetchRequest()) {
        do {
            notesArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Новая запись", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
    
            
            let newItem = Notes(context: self.context)
            newItem.name = textField.text!
            newItem.text = "демо"
            
            

            self.notesArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        
        // Создаём текстовое поле для ввода товара
        alert.addTextField { alertTextField in
            alertTextField.placeholder = ""
            textField = alertTextField
        }
        
        // Запускаем
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

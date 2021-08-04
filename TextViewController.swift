//
//  TextViewController.swift
//  Notepad
//
//  Created by  Stepanok Ivan on 03.08.2021.
//

import UIKit
import CoreData

class TextViewController: UIViewController {

    
    var notesArray = [Notes]()
    
    var selectNote : Notes? {
        didSet {
            loadItems()
            
        }
    }
    
    @IBOutlet weak var titleLabel: UITextField!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    @IBOutlet weak var textScreen: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        textScreen.text = selectNote?.text
        // Do any additional setup after loading the view.
    }
    
    @IBAction func textEdit(_ sender: UITextField) {
        
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        selectNote?.text = textScreen.text

        saveItems()
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    
    
}



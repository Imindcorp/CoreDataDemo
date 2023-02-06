//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Ilnur Mindubayev on 05.02.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // Создаем ссылку на Контекст (Reference to managed object context)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data для UITableView
    var items:[Person]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Достаем обьекты из Core Data и обновляем таблицу (Get items from Core Data)
        fetchPeople()
        
    }
    
    
    // Demo to class relationships
    
    func relationshipDemo() {
        
        // Create a family
        let family = Family(context: context)
        family.name = "Abc Family"
        
        // Create a person
        let person = Person(context: context)
        person.name = "Maggie"
    
        // add person to family
        family.addToPeople(person)
        
        // Save context
        try! context.save()
        
    }
    
    func fetchPeople() {
        
        // Retrieve - получаем обьекты из Core Data (fetch the data from Core Data to display in the tableview)
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            // Определяем NSFetchRequest для фильтрации полученных объектов
            // Set the filtering and soriting on the request, for exaple NSPredicate format "name CONTAINS 'Ted'"
            // %@ - that contains dynamic variable, that defined after ","
//             let pred = NSPredicate(format: "name CONTAINS %@", "Иль")
//             request.predicate = pred
            
            // Также можем отсортировать
            // sort by something, ascending or not ( up or down )
            // can be sorted by multiple paramters, for example by name, then by surname etc
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Error fetching data")
        }
        
        
        
    }
    

    @IBAction func addTapped(_ sender: Any) {
        
        // create alert
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // configure button handler
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // get the textfield for the alert
            
            let textfield = alert.textFields![0]
            
            // Create - Создаем новый обьект Person в контексте, для последующего сохранения
            
            let newPerson = Person(context: self.context)
            newPerson.name = textfield.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            // Сохраняем этот обьект
            
            do {
               try self.context.save()
            }
            catch {
                print("Error saving data")
            }
            
            // Refetch the data
            
            self.fetchPeople()
        }
        
        // add button
        
        alert.addAction(submitButton)
        
        // Show alert
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return number of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // to do get person from array and set the label
        
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update - по нажатию на ячейку мы обращаемся к выбранному обьекту из массива
        // selected Person
        let person = self.items![indexPath.row]
        
        // create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        // configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // Изменяем имя
            // edit name property of person object
            person.name = textfield.text
            
            // Сохраняем те изменения, которые произошли в контексте
            // save the data
            do {
                try self.context.save()
            }
            catch {
                print("error editing name")
            }
            
            // re-fetch the data
            self.fetchPeople()
        
            
            
        }
        
        // add save button
        alert.addAction(saveButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Delete - выбираем обьект для удаления, из массива
            // which person to remove
            let personToRemove = self.items![indexPath.row]
            
            // удаляем его
            // remove the person
            self.context.delete(personToRemove)
            
            // сохраняем изменения
            // save the data
            do {
                try self.context.save()
            } catch {
                print("error deleting person")
            }
            
            // re-fetch the data
            self.fetchPeople()
            
        }
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}

//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sebastian Lofaro on 3/30/19.
//  Copyright © 2019 Pixel Magic. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //Mark: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What will happen when the add category button is clicked
            if let textFieldText = textField.text {
                let newCategory = Category(context: self.context)
                newCategory.name = textFieldText
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //Mark: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    //Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //Mark: - Data Manipulation Methods
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
        }
        catch {
            print("Error Saving Categories: \(error)")
        }
        self.tableView.reloadData()
    }
    
}

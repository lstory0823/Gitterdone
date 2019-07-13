//
//  ViewController.swift
//  Gitterdone
//
//  Created by Liam Story on 7/12/19.
//  Copyright © 2019 Liam Story. All rights reserved.
//

import UIKit

class GitterdoneViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Go on first date with Lizzie"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Go on second date with Lizzie"
        itemArray.append(newItem2)
        
        // Do any additional setup after loading the view.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.completed == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].completed = !itemArray[indexPath.row].completed
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
//MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Gitterdone Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the add item button
            let newestItem = Item()
            newestItem.title = textField.text!
            
            self.itemArray.append(newestItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}


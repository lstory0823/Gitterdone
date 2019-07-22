//
//  ViewController.swift
//  Gitterdone
//
//  Created by Liam Story on 7/12/19.
//  Copyright © 2019 Liam Story. All rights reserved.
//

import UIKit
import RealmSwift

class GitterdoneViewController: SwipeTableViewController {

    var gitterdoneItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet {
    
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitterdoneItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = gitterdoneItems?[indexPath.row] {
            
            cell.textLabel?.text = gitterdoneItems?[indexPath.row].title
            
            cell.accessoryType = item.completed == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = ""
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item =  gitterdoneItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.completed = !item.completed
                }

            } catch {
                print("Error Saving Data: \(error)")
            }
            
        }
        tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Gitterdone Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the add item button
            
            if let currentCategory = self.selectedCategory {
                do {
                    
                    try self.realm.write {
                        
                        let newestItem = Item()
                        
                        newestItem.title = textField.text!
                        
                        newestItem.dateCreated = Date()
                        
                        print(newestItem.dateCreated)
                        
                        currentCategory.items.append(newestItem)
                    }
                    
                } catch {
                    print("Error saving Item to Realm: \(error)")
                }

            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func loadItems() {

        gitterdoneItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemToDelete = gitterdoneItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error Deleting Category: \(error)")
            }
            
        }
        
    }

}


//MARK: - Search Bar Methods
extension GitterdoneViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
        else {
            
            gitterdoneItems = gitterdoneItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true  )
            
            tableView.reloadData()

        }

    }
    
}

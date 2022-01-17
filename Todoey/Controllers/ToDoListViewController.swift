import UIKit

class ToDoListViewController: UITableViewController, UITextFieldDelegate {
    var alertActionAdd = UIAlertAction()
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadItems()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        cell.contentConfiguration = content
        
//        item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        cell.accessoryType = (item.done ? .checkmark : .none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        itemArray[indexPath.row].done.toggle()
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        
        
        
    }
    
    //MARK: - Add new Items to the list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alertActionAdd = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item(title: textField.text!)
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
    
        }
        alertActionAdd.isEnabled = false
        
        let alertActionDismiss = UIAlertAction(title: "Cancel", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.delegate = self
            alertTextField.placeholder = "Create New Item"
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        alert.addAction(alertActionAdd)
        alert.addAction(alertActionDismiss)
        
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        }
        
    }
    
    @objc func dismissOnTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
//        newString != "" ? (alertActionAdd.isEnabled = true) : (alertActionAdd.isEnabled = false)
        alertActionAdd.isEnabled = (newString != "" ? true : false)
        return true
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array/ \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
}


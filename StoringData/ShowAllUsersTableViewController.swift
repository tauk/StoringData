//
//  ShowAllUsersTableViewController.swift
//  StoringData
//
//  Created by Tauseef Kamal on 12/12/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//
import CoreData
import UIKit

class ShowAllUsersTableViewController: UITableViewController {
    
    var names = [String]()
    var ages = [Int]()
    var emails = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        do {
            let persons = try managedContext.fetch(request)
            
            for person in persons {
                let personObject = person as! NSManagedObject
                
                let name = personObject.value(forKey: "name") as! String
                let age = personObject.value(forKey: "age") as! Int
                let email = personObject.value(forKey:"email") as! String
                
                names.append(name)
                ages.append(age)
                emails.append(email)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllUsersViewCell", for: indexPath) as! ShowAllUserTableViewCell

        // Configure the cell...
        let row = indexPath.row
        
        cell.nameLabel.text = names[row]
        cell.ageLabel.text = "\(ages[row])"
        cell.emailLabel.text = emails[row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

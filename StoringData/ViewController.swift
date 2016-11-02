//
//  ViewController.swift
//  StoringData
//
//  Created by Tauseef Kamal on 10/26/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var personName: UITextField!
    
    @IBOutlet weak var personAge: UITextField!
    
    @IBOutlet weak var personEmail: UITextField!
    
    @IBOutlet weak var lblPersonData: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBAction func addNewPerson(_ sender: AnyObject) {
        //get the name 
        let name = personName.text
        
        //get age
        let age = Int(personAge.text!)
        
        //get email 
        let email = personEmail.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //get the entity for person
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        //using the entity create a managed object person
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //set the values for the person object using the column names (keys)
        person.setValue(name, forKey: "name")
        person.setValue(age, forKey: "age")
        person.setValue(email, forKey: "email")
        
        //Insert the person record into the data base
        do {
            try managedContext.save()
        
            lblStatus.text = "Record saved!"
        } catch let error as NSError  {
            lblStatus.text = "Record not saved \(error), \(error.userInfo)"
        }
    }
    
    //show all records
    @IBAction func showRecords(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        do {
            let persons = try managedContext.fetch(request)
         
            var data = ""
            for person in persons {
                let personObject = person as! NSManagedObject
                
                let name = personObject.value(forKey: "name") as! String
                let age = personObject.value(forKey: "age") as! Int
                let email = personObject.value(forKey:"email") as! String
                
                data.append("\n\(name) \(age) \(email)")
            }
            
            //display data in the label
            lblPersonData.text = data
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    //get person by name and display his data
    @IBAction func getPerson(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        let name = personName.text
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        //Confugure the predicate
        let pred = NSPredicate(format: "(name = %@)", name!) //like where in SQL select
        request.predicate = pred
        
        do {
            let persons = try managedContext.fetch(request)
            
            //array count is 0 - no Person found with the we specified in the Predicate
            if (persons.count == 0) {
                lblPersonData.text = "No record found for \(name)."
                return
            }
            let person = persons[0] as! NSManagedObject
            
            //we already have the name so get the age and email now
            let age = person.value(forKey: "age") as! Int
            let email = person.value(forKey:"email") as! String

            //display the data
            personAge.text = String(age)
            personEmail.text = email
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    //delete all records
    @IBAction func deleteAllRecords(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        var deleteCount = 0
        
        do {
            let persons = try managedContext.fetch(request) //we get an array of persons
        
            //iterate over persons array and delete each person record in it
            for person in persons {
                
                managedContext.delete(person as! NSManagedObject)
                
                do {
                    //commit
                    try managedContext.save()
                    
                    deleteCount = deleteCount + 1
                } catch{
                    let deleteError = error as NSError
                    print(deleteError)
                }
                
            }
            
        } catch {
            let deleteError = error as NSError
            print(deleteError)
        }

        lblPersonData.text = "\(deleteCount) records deleted"
    }
    
    //Update the Person by name
    @IBAction func updatePerson(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        let name = personName.text
        
        let age = Int(personAge.text!)
        
        let email = personEmail.text
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        //Configure the predicate
        let pred = NSPredicate(format: "(name = %@)", name!)
        request.predicate = pred
        
        var updateCount = 0
        
        do {
            let persons = try managedContext.fetch(request)
        
            //array count is 0 - no Person found with the we specified in the Predicate
            if (persons.count == 0) {
                lblPersonData.text = "No record found for \(name). No update done!"
                return
            }
            let person = persons[0] as! NSManagedObject
            
            //set the person attribute values to the new values
            person.setValue(age, forKey: "age")
            person.setValue(email, forKey: "email")
                
            do {
                try managedContext.save() //commit the changes to attribute values
                updateCount = updateCount + 1
            } catch{
                let updateError = error as NSError
                print(updateError)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        lblPersonData.text = "\(updateCount) record updated"
    }
    
    //delete a Person by name
    @IBAction func deletePerson(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        let name = personName.text
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        // Configure Fetch Request
        request.entity = entityDescription
        
        //Configure the predicate and it to the request predicate
        let pred = NSPredicate(format: "(name = %@)", name!)
        request.predicate = pred
        
        do {
            let persons = try managedContext.fetch(request)
            
            if (persons.count == 0) {
                lblPersonData.text = "No record found for \(name). No delete done!"
                return
            }
        
            let person = persons[0] as! NSManagedObject
            
            //delete this record
            managedContext.delete(person)
            
            do {
                //save the change done - which is the above delete
                try managedContext.save() //commit
            } catch{
                let updateError = error as NSError
                print(updateError)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        lblPersonData.text = "record for \(name) deleted"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


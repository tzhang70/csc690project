import UIKit
import CoreData

class TeacherScheduleViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var timeSchedule: [NSManagedObject] = []
    
    @IBAction func addSchedule(_ sender: UIBarButtonItem) {
        //adds alert and display message
        let alert = UIAlertController(title: "New Time", message: "Add a time to your schedule", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let timeSchedToSave = textField.text else {
                return
            }
            self.save(schedule: timeSchedToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert,animated: true,completion: nil)
      
    }
    //saves the time entry into core data
    func save(schedule: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Time", in: managedContext)!
        
        let time = NSManagedObject(entity: entity, insertInto: managedContext)
        
        time.setValue(schedule, forKeyPath: "schedule")
        
        do{
            try managedContext.save()
            timeSchedule.append(time)
        } catch let error as NSError {
            print("Could not save time. \(error), \(error.userInfo)")
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            timeSchedule.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let requestDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        
        
        do{
            let arrTimeObj = try context.fetch(requestDelete)
            
            let objectUpdate = arrTimeObj as! [NSManagedObject]
            
            context.delete(objectUpdate[indexPath.row])
            try context.save()
        } catch{
            print("Error. Failed to delete")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Time")
        
        do{
            timeSchedule = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not retrieve data, \(error), \(error.userInfo)")
        }
    }
    //delete not functioning?
    
}


extension TeacherScheduleViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return timeSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let time = timeSchedule[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = time.value(forKeyPath: "schedule") as? String
        return cell
    }
}

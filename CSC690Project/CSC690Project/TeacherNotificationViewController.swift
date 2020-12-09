
import UIKit
import CoreData

class TeacherNotificationViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var timeSchedule : [NSManagedObject] = []
    
    
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
        self.tableView.reloadData()
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        self.tableView.reloadData()
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
    
}

extension TeacherNotificationViewController: UITableViewDataSource{
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

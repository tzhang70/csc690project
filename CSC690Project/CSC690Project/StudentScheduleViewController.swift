
import UIKit
import CoreData
class StudentScheduleViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var timeSchedule: [NSManagedObject] = []
    var timeAdded: [NSManagedObject] = []
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
    //supposedly selects the row and adds that time schedule to the notification section
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let requestData = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeAdded")
        do{
            let timeSchedToSave = try context.fetch(requestData)
            let objectUpdate = timeSchedToSave as! [NSManagedObject]
            context.insert(objectUpdate[indexPath.row])
            try context.save()
        } catch{
            print("Failed to add to students schedule")
        }
        
        
    }
    func save(scheduleToAdd: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TimeAdded", in: managedContext)!
        
        let time = NSManagedObject(entity: entity, insertInto: managedContext)
        
        time.setValue(scheduleToAdd, forKeyPath: "stuSched")
        
        do{
            try managedContext.save()
            timeAdded.append(time)
        } catch let error as NSError {
            print("Could not save time. \(error), \(error.userInfo)")
        }
    }
}


extension StudentScheduleViewController: UITableViewDataSource{
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

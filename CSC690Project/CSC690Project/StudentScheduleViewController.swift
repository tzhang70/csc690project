
import UIKit
import CoreData
class StudentScheduleViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var timeSchedule: [NSManagedObject] = []
    
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

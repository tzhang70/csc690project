
import UIKit
import CoreData

class TeacherNotificationViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var timeSchedule : [NSManagedObject] = []
    
    
//    func deleteTime(Id:String){
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//         
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Time")
//        fetchRequest.predicate = NSPredicate(format: "id= %@", "\(Id)")
//        do{
//            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
//
//            for entity in fetchedResults! {
//                managedContext.delete(entity)
//                do{
//                    try managedContext.save()
//                }
//                catch let error as Error?{
//                    print(error?.localizedDescription)
//                }
//            }
//        }
//        catch _ {
//            print("Could not delete that entity")
//        }
//
//    }
    
    override func viewDidLoad() {
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

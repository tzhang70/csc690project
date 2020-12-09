
import UIKit
import CoreData
class StudentNotificationViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var timeAdded: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeAdded")
        
        do{
            timeAdded = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not retrieve data, \(error), \(error.userInfo)")
        }
    }
    
}
extension StudentNotificationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let time = timeAdded[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = time.value(forKeyPath: "stuSchedule") as? String
        return cell
    }
}

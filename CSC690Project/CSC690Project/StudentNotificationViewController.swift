
import UIKit

class StudentNotificationViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var times = ["Monday 12:30 - 1:00pm", "Tuesday 1:00pm - 1:30pm"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    
}
extension StudentNotificationViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = times[indexPath.row]
        
        return cell
    }
}

import UIKit

class MainTableViewController: UITableViewController {
    
    let places = [
        "DoubleB", "Isaac Cathedral", "Isaac Square",
        "Angleterre Cinema Lounge", "Vasileostrovskiy Market",
        "New Holland Island", "Prostovino", "Bekitzer", "Mad Espresso Team",
        "Smena Cafe", "Krestovskiy Island", "Pulkovo Airport"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.placeNameLabel.text = places[indexPath.row]
        cell.placeImage.image = UIImage(named: places[indexPath.row])
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
         cell.placeImage.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: - Navigation
    
}

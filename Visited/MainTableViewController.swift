import UIKit

class MainTableViewController: UITableViewController {
    
    
    let places = Place.fillPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.placeNameLabel.text = places[indexPath.row].name
        cell.placeLocationLabel.text = places[indexPath.row].location
        cell.placeTypeLabel.text = places[indexPath.row].type.rawValue
        
        cell.placeImage.image = UIImage(named: places[indexPath.row].imageName)
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        cell.placeImage.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    // MARK: - Navigation
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {
        
    }
}

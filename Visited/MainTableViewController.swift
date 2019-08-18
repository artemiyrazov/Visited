import UIKit

class MainTableViewController: UITableViewController {
    
    
    var places = Place.fillPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]

        cell.placeNameLabel.text = place.name
        cell.placeLocationLabel.text = place.location
        cell.placeTypeLabel.text = place.type.rawValue
        
        if place.image == nil {
            cell.placeImage.image = UIImage(named: place.imageName!)
        } else {
            cell.placeImage.image = place.image
        }
        
        
        
        
        
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        cell.placeImage.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    // MARK: - Navigation
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.saveNewPlace()
        places.append(newPlaceVC.newPlace!)
        tableView.reloadData()
        
    }
}

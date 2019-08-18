import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.placeNameLabel.text = place.name
        cell.placeLocationLabel.text = place.location
//        cell.placeTypeLabel.text = place.type.rawValue
        cell.placeTypeLabel.text = place.type

        DispatchQueue.main.async {
            cell.placeImage.image = UIImage(data: place.imageData!)
            cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
            cell.placeImage.clipsToBounds = true
        }


        return cell
    }
    
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete") { (_, _) in
                                                    StorageManager.deleteObject(place)
                                                    tableView.deleteRows(at: [indexPath], with: .automatic)
                                                    }
        
        return [deleteAction]
        }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {

        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.saveNewPlace()
        tableView.reloadData()

    }
}

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sortingButton: UIBarButtonItem!
    
    var places: Results<Place>!
    var ascendingSorting = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.placeNameLabel.text = place.name
        cell.placeLocationLabel.text = place.location
        cell.placeTypeLabel.text = place.type.rawValue

        
        cell.placeImage.image = UIImage(data: place.imageData!)
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2
        cell.placeImage.clipsToBounds = true
        


        return cell
    }
    
    
    
    // MARK: - Table view delegate
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete") { (_, _) in
                                                    StorageManager.deleteObject(place)
                                                    tableView.deleteRows(at: [indexPath], with: .automatic)
                                                    }
        
        return [deleteAction]
        }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {

        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()

    }
    
    @IBAction func sortingType(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        if ascendingSorting {
            sortingButton.image = #imageLiteral(resourceName: "AscendingSorting")
        } else {
            sortingButton.image = #imageLiteral(resourceName: "DescendingSorting")
        }
        
        sorting()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
        
    }
}

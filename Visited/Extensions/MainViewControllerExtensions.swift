import UIKit
import RealmSwift

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    internal func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter(
            "name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR privateType CONTAINS[c] %@",
            searchText, searchText, searchText)
        
        tableView.reloadData()
    }
}

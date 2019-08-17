import Foundation

enum PlaceType: String {
    case Cafe
    case Bar
    case Restaurant
    case Park
    case UrbanSpace = "Urban Space"
    case TransportNode = "Transport Node"
    case Other
}

struct Place {
    var name: String
    var location: String
    var type: PlaceType
    var imageName: String
}

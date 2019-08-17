import Foundation

enum PlaceType: String, CaseIterable {
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
    
    static let places = [
        "DoubleB", "Isaac Cathedral", "Isaac Square",
        "Angleterre Cinema Lounge", "Vasileostrovskiy Market",
        "New Holland Island", "Prostovino", "Bekitzer", "Mad Espresso Team",
        "Smena Cafe", "Krestovskiy Island", "Pulkovo Airport"
    ]

    static func fillPlaces() -> [Place] {
        var newPlaces = [Place]()
        
        for place in places {
            newPlaces.append(Place(name: place, location: "Saint-Petersburg", type: .Other, imageName: place))
        }
        
        return newPlaces
    }
    
}



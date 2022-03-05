import Foundation

extension PlacesViewController {
    @objc func showLocation(_ location: [String: String]) {
        if let lonString = location["longitude"], let latString = location["latitude"] {
            if let longitude = CLLocationDegrees(lonString), let latitude = CLLocationDegrees(latString) {
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                showLocationWithCoordinates(coordinates)
            }
        }
    }
    
    private func showLocationWithCoordinates(_ coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
        zoomAndPanMapView(toLocation: location)
        
    }
    
    private func showLocationOfPlace(_ place: String) {
        searchBarTextDidBeginEditing(searchBar)
        searchBar.text = place
        searchBar(searchBar, textDidChange: place)
        searchBar.becomeFirstResponder()
        searchBarSearchButtonClicked(searchBar)
    }
}

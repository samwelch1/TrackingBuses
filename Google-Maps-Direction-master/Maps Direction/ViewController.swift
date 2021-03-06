//
//  ViewController.swift
//  Maps Direction
//
//  Created by YUNG BOTCH on 2/9/17.
//  Copyright © 2017 balitax. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
	case startLocation
	case destinationLocation
}

class ViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
	
	@IBOutlet weak var googleMaps: GMSMapView!
	@IBOutlet weak var startLocation: UITextField!
	@IBOutlet weak var destinationLocation: UITextField!
	

	var locationManager = CLLocationManager()
	var locationSelected = Location.startLocation
	
	var locationStart = CLLocation()
	var locationEnd = CLLocation()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startMonitoringSignificantLocationChanges()
		
		//Your map initiation code
		let camera = GMSCameraPosition.camera(withLatitude: 41.8781, longitude: -87.6298, zoom: 15.0)
		
		self.googleMaps.camera = camera
		self.googleMaps.delegate = self
		self.googleMaps?.isMyLocationEnabled = true
		self.googleMaps.settings.myLocationButton = true
		self.googleMaps.settings.compassButton = true
		self.googleMaps.settings.zoomGestures = true
		
        //var Chicago = CLLocation(latitude: 41.8781, longitude: -87.6298)
        //var LA = CLLocation(latitude: 34.0522, longitude: 118.2437)
        //drawPath(startLocation: LA, endLocation: Chicago)
	}
	
	// MARK: function for create a marker pin on map
	func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2DMake(latitude, longitude)
		marker.title = titleMarker
		marker.icon = iconMarker
		marker.map = googleMaps
	}
	
	//MARK: - Location Manager delegates
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error to get location : \(error)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = locations.last
		
//		let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
		
		let Chicago = CLLocation(latitude: 41.8781, longitude: -87.6298)
		let somewhere = CLLocation(latitude: 40.8781, longitude: -87.6298)
		createMarker(titleMarker: "Chicago", iconMarker: #imageLiteral(resourceName: "schoolbus-1501332_960_720"), latitude: Chicago.coordinate.latitude, longitude: Chicago.coordinate.longitude)
		
        //createMarker(titleMarker: "Lokasi Aku", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
		
		//drawPath(startLocation: location!, endLocation: Chicago)
        drawPath(startLocation: somewhere, endLocation: Chicago)
		
//		self.googleMaps?.animate(to: camera)
        
        
		self.locationManager.stopUpdatingLocation()
		
	}
	
	// MARK: - GMSMapViewDelegate
	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		googleMaps.isMyLocationEnabled = true
	}
	
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		googleMaps.isMyLocationEnabled = true
		
		if (gesture) {
			mapView.selectedMarker = nil
		}
	}
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		googleMaps.isMyLocationEnabled = true
		return false
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		print("COORDINATE \(coordinate)") // when you tapped coordinate
	}
	
	func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
		googleMaps.isMyLocationEnabled = true
		googleMaps.selectedMarker = nil
		return false
	}
	
	

	//MARK: - this is function for create direction path, from start location to desination location
	
	func drawPath(startLocation: CLLocation, endLocation: CLLocation)
	{
		let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
		let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
		
		
		let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
		
		Alamofire.request(url).responseJSON { response in
			
			print(response.request as Any)  // original URL request
			print(response.response as Any) // HTTP URL response
			print(response.data as Any)     // server data
			print(response.result as Any)   // result of response serialization
			
			let json = JSON(data: response.data!)
			let routes = json["routes"].arrayValue
            
            var duration = ""
			// print route using Polyline
			for route in routes
			{
				let routeOverviewPolyline = route["overview_polyline"].dictionary
				let points = routeOverviewPolyline?["points"]?.stringValue
                duration = route["duration"].stringValue
				let path = GMSPath.init(fromEncodedPath: points!)
				let polyline = GMSPolyline.init(path: path)
				polyline.strokeWidth = 4
				polyline.strokeColor = UIColor.red
				polyline.map = self.googleMaps
			}
            // CGRectMake has been deprecated - and should be let, not var
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            
            // you will probably want to set the font (remember to use Dynamic Type!)
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            
            // and set the text color too - remember good contrast
            label.textColor = .black
            
            // may not be necessary (e.g., if the width & height match the superview)
            // if you do need to center, CGPointMake has been deprecated, so use this
            label.center = CGPoint(x: 160, y: 284)
            
            // this changed in Swift 3 (much better, no?)
            label.textAlignment = .center
            label.text = duration
            self.view.addSubview(label)
		}
	}
	
	// MARK: when start location tap, this will open the search location
	@IBAction func openStartLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .startLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	// MARK: when destination location tap, this will open the search location
	@IBAction func openDestinationLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .destinationLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	
	// MARK: SHOW DIRECTION WITH BUTTON
	@IBAction func showDirection(_ sender: UIButton) {
		// when button direction tapped, must call drawpath func
		self.drawPath(startLocation: locationStart, endLocation: locationEnd)
	}

}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension ViewController: GMSAutocompleteViewControllerDelegate {
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("Error \(error)")
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		
		// Change map location
		let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
		)
		
		// set coordinate to text
		if locationSelected == .startLocation {
			startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
			locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		} else {
			destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
			locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		}
		
		
		self.googleMaps.camera = camera
		self.dismiss(animated: true, completion: nil)
		
	}
	
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
}

public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
	
}

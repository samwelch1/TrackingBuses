//
//  MapTasks.swift
//  Tracking Buses SE
//
//  Created by NCPRG on 4/13/18.
//  Copyright © 2018 ncprg. All rights reserved.
//

import Foundation

class MapTasks: NSObject {
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    override init() {
        super.init()
    }
    
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status: String, _ success: Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                directionsURLString = directionsURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let directionsURL = NSURL(string: directionsURLString)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let directionsData = NSData(contentsOfURL: directionsURL!)
                    
                    var error: NSError?
                    let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(directionsData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as Dictionary<NSObject, AnyObject>
                    
                    if (error != nil) {
                        println(error)
                        completionHandler(status: "", success: false)
                    }
                    else {
                        let status = dictionary["status"] as String
                        
                        if status == "OK" {
                            self.selectedRoute = (dictionary["routes"] as Array<Dictionary<NSObject, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as Dictionary<NSObject, AnyObject>
                            
                            let legs = self.selectedRoute["legs"] as Array<Dictionary<NSObject, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as Dictionary<NSObject, AnyObject>
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as Double, startLocationDictionary["lng"] as Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as Dictionary<NSObject, AnyObject>
                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as Double, endLocationDictionary["lng"] as Double)
                            
                            self.originAddress = legs[0]["start_address"] as String
                            self.destinationAddress = legs[legs.count - 1]["end_address"] as String
                            
                            self.calculateTotalDistanceAndDuration()
                            
                            completionHandler(status: status, success: true)
                        }
                        else {
                            completionHandler(status: status, success: false)
                        }
                    }
                })
            }
            else {
                completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute["legs"] as Array<Dictionary<NSObject, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as Dictionary<NSObject, AnyObject>)["value"] as UInt
            totalDurationInSeconds += (leg["duration"] as Dictionary<NSObject, AnyObject>)["value"] as UInt
        }
        
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
    
    
    
}

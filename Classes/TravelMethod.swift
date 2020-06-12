//
//  TravelMethod.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import MapKit

public enum TravelMethod: String, Codable {
    case bike, car, none, walk
    
    var transportType: MKDirectionsTransportType {
        switch self {
        case .bike: return .walking
        case .car: return .automobile
        case .none: return .walking
        case .walk: return .walking
        }
    }
}

public extension MKDirections {
    
    convenience init(travelMethod: TravelMethod, location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) {
        let request = Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location1))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location2))
        request.requestsAlternateRoutes = true
        request.transportType = travelMethod.transportType
        self.init(request: request)
    }
}

//
//  OpenMapResponse.swift
//  Dukan
//
//  Created by mohammed balegh on 13/02/2023.
//

import Foundation

struct LocationEntity: Codable {
    let lat, lng: Double?
    let location: String?
}

struct RouteScreenData {
    let duration: Double
    let distance: Double
    let geometry: [LocationEntity]

    init(model: OpenStreetMapResponse) {
        let leg = model.routes?.first?.legs?.first

        if let leg {
            var list = RouteScreenData.handle(leg: leg)
            if let leg2 = model.routes?.first?.legs?[o: 1] {
                list += RouteScreenData.handle(leg: leg2)
            }
            geometry = list
        } else {
            geometry = []
        }

        duration = model.routes?.first?.duration ?? 0
        distance = model.routes?.first?.distance ?? 0

        print(duration, distance)
    }

   static func handle(leg: Leg) -> [LocationEntity] {
        var steps: [Step] = []
        var coordinates: [[Double]] = []

        leg.steps.unwrapped(or: []).forEach({
            steps.append($0)
        })

        steps.forEach({
            $0.geometry?.coordinates?.forEach({
                coordinates.append($0)
            })
        })

        return coordinates.map({ item in
            let lng = item.first
            let lat = item.last
            return LocationEntity(lat: lat, lng: lng, location: nil)
        })
    }
}

// MARK: - Welcome
struct OpenStreetMapResponse: Codable {
    let code: String?
    let routes: [Route]?
//    let waypoints: [Waypoint]?
}

// MARK: - Route
struct Route: Codable {
    let geometry: Geometry?
    let legs: [Leg]?
    let weightName: String?
    let weight, duration, distance: Double?

    enum CodingKeys: String, CodingKey {
        case geometry, legs
        case weightName = "weight_name"
        case weight, duration, distance
    }
}

// MARK: - Leg
struct Leg: Codable {
    let steps: [Step]?
    let summary: String?
    let weight, duration, distance: Double?
}

// MARK: - Step
struct Step: Codable {
    let geometry: Geometry?
    let maneuver: Maneuver?
//    let mode: Mode?
//    let drivingSide: DrivingSide?
    let name: String?
    let intersections: [Intersection]?
    let weight, duration, distance: Double?

    enum CodingKeys: String, CodingKey {
        case geometry, maneuver
//        case drivingSide = "driving_side"
        case name, intersections, weight, duration, distance
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let coordinates: [[Double]]?
//    let type: TypeEnum?
}

// MARK: - Intersection
struct Intersection: Codable {
    let out: Int?
    let entry: [Bool]?
    let bearings: [Double]?
    let location: [Double]?
    let intersectionIn: Double?
    let lanes: [Lane]?

    enum CodingKeys: String, CodingKey {
        case out, entry, bearings, location
        case intersectionIn = "in"
        case lanes
    }
}

// MARK: - Lane
struct Lane: Codable {
    let valid: Bool?
    let indications: [String]?
}

// MARK: - Maneuver
struct Maneuver: Codable {
    let bearingAfter, bearingBefore: Double?
    let location: [Double]?
    let type: String?
    let modifier: String?

    enum CodingKeys: String, CodingKey {
        case bearingAfter = "bearing_after"
        case bearingBefore = "bearing_before"
        case location, type, modifier
    }
}

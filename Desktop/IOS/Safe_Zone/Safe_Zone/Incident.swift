//
//  Incident.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//
import SwiftUI
import Foundation
import CoreLocation

struct Incident: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D
    let photo: UIImage?
}

class IncidentStore: ObservableObject {
    @Published var incidents: [Incident] = []
    
    func addIncident(_ incident: Incident) {
        incidents.append(incident)
    }
}



